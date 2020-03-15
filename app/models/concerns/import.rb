=begin
  This can be called from db:seeds, maybe

  
=end

module Import

  class ImportBook < ApplicationRecord
    has_many :accounts
    has_many :entries
    has_many :bank_statements
    has_many :ofxes

    self.table_name = 'books'
  end
  class ImportAccount < ApplicationRecord
    belongs_to :book
    self.table_name = 'accounts'
  end

  class ImportEntry < ApplicationRecord
    belongs_to :book
    self.table_name = 'entries'
  end

  class ImportSplit < ApplicationRecord
    # belongs_to :accounts
    # belongs_to :entry
    self.table_name = 'splits'
  end

  class ImportIcash
    attr_accessor :book, :yaml_path, :save

    def initialize(save=false)
      @save = save
      @yaml_path = Rails.root.join('../../Common/dumps')
    end

    def import_all
      create_book
      import_users
      import_accounts
      import_entries
      import_splits
      import_bank_statements
      import_ofxes
      import_deposits
      import_sales_revenues
      import_other_revenues
      import_cash_out
      
      return "done"
    end

    def create_book
      @book = ImportBook.new
      book.name = "RCash"
      book.root = SecureRandom.uuid
      book.assets = SecureRandom.uuid
      book.liabilities = SecureRandom.uuid
      book.equity = SecureRandom.uuid
      book.income = SecureRandom.uuid
      book.expenses = SecureRandom.uuid
      book.checking = SecureRandom.uuid
      book.savings = SecureRandom.uuid
      settings = {skip:true}
      if save
        book.save if save
      else
        book.id = 1
      end
      book
    end

    def import_branches
      create_book
      import_users
      filepath = yaml_path + 'accounts.yaml'
      accounts_array = YAML.load_file(filepath)
      acct_hash = {}
      # child_hash = {}
      accounts_array.each do |acct|
        acct.delete('guid')
        acct.delete('created_at')
        acct.delete('updated_at')
        acct['book_id'] = 1
        set_uuid(acct)
        if !acct['level'].nil? && acct['level'] <= 3 # root template
          acct_hash[acct['id']] = acct
        #   if child_hash.has_key?(acct['parent_id'])
        #     child_hash[acct['parent_id']] << acct['id']
        #   else
        #     child_hash[acct['parent_id']] = [acct['id']]
        #   end
        end
      end

      baseAccounts = []
      curr_ids = acct_hash.keys
      rep_ids = {}
      nxt_id = 1
      curr_ids.each.with_index{|v,i| rep_ids[v] = (i+nxt_id)}
      acct_hash.each do |k,v|
        v['id'] = rep_ids[v['id']]
        unless v['parent_id'].nil?
          v['parent_id'] = rep_ids[v['parent_id']]
        end 
        baseAccounts << v
      end
      # return baseAccounts
      
      ImportAccount.create(baseAccounts) if save
      return "baseAccounts,book"
    end


    def import_accounts
      filepath = yaml_path + 'accounts.yaml'
      accounts_array = YAML.load_file(filepath)
      accounts_array.each do |acct|
        acct.delete('guid')
        acct['book_id'] = book.id

        if acct['account_type'] == 'ROOT' && acct['name'] != "Template Root"
          acct['uuid'] = book.root
        elsif acct['parent_id'] == 1
          case acct['account_type']
          when 'ROOT'
            acct['uuid'] = book.root
          when 'ASSET'
            acct['uuid'] = book.assets
          when 'INCOME'
            acct['uuid'] = book.income
          when 'LIABILITY'
            acct['uuid'] = book.liabilities
          when 'EXPENSE'
            acct['uuid'] = book.expenses
          when 'EQUITY'
            acct['uuid'] = book.equity
          when 'BANK'
            acct['uuid'] = SecureRandom.uuid
          else
            raise "A root child account has invalid account_type"
          end
        else
          # special accounts defined in book or default
          case acct['name']
          when 'Checking'
            acct['uuid'] = book.checking
          when 'Savings'
            acct['uuid'] = book.savings
          else
            acct['uuid'] = SecureRandom.uuid
          end
        end
      end
      ImportAccount.create(accounts_array) if save
      return "account"
    end 

    def set_uuid(acct)
      if acct['account_type'] == 'ROOT' && acct['name'] != "Template Root"
        acct['uuid'] = book.root
      elsif acct['parent_id'] == 1
        case acct['account_type']
        when 'ROOT'
          acct['uuid'] = book.root
        when 'ASSET'
          acct['uuid'] = book.assets
        when 'INCOME'
          acct['uuid'] = book.income
        when 'LIABILITY'
          acct['uuid'] = book.liabilities
        when 'EXPENSE'
          acct['uuid'] = book.expenses
        when 'EQUITY'
          acct['uuid'] = book.equity
        when 'BANK'
          acct['uuid'] = SecureRandom.uuid
        else
          raise "A root child account has invalid account_type"
        end
      else
        # special accounts defined in book or default
        case acct['name']
        when 'Checking'
          acct['uuid'] = book.checking
        when 'Savings'
          acct['uuid'] = book.savings
        else
          acct['uuid'] = SecureRandom.uuid
        end
      end
    end

    def import_entries
      filepath = yaml_path + 'entries.yaml'
      entries_array = YAML.load_file(filepath)
      entries_array.map{|e| e['book_id'] = book.id}
      ImportEntry.create(entries_array) if save
      return "entries"
    end

    def import_splits
      filepath = yaml_path + 'splits.yaml'
      splits_array = YAML.load_file(filepath)
      ImportSplit.create(splits_array) if save
      return "why"
    end

    def import_deposits
      filepath = yaml_path + 'deposits.yaml'
      deposits_array = YAML.load_file(filepath)
      deposits_array.each do |acct|
        acct.delete('created_at')
        acct.delete('updated_at')
      end
      Deposit.create(deposits_array) if save
      return "deposits"
    end

    def import_sales_revenues
      filepath = yaml_path + 'sales_revenues.yaml'
      sales_revenues_array = YAML.load_file(filepath)
      sales_revenues_array.each do |acct|
        acct.delete('created_at')
        acct.delete('updated_at')
      end
      SalesRevenue.create(sales_revenues_array) if save
      return "sales"
    end

    def import_other_revenues
      filepath = yaml_path + 'other_revenues.yaml'
      other_revenues_array = YAML.load_file(filepath)
      other_revenues_array.each do |acct|
        acct.delete('created_at')
        acct.delete('updated_at')
      end
    OtherRevenue.create(other_revenues_array) if save
      return "revenue"
    end

    def import_cash_out
      filepath = yaml_path + 'cash_out.yaml'
      cash_out_array = YAML.load_file(filepath)
      cash_out_array.each do |acct|
        acct.delete('created_at')
        acct.delete('updated_at')
      end
      CashOut.create(cash_out_array) if save
      return "cash out"
    end

    def import_bank_statements
      filepath = yaml_path + 'bank_statements.yaml'
      bank_statements_array = YAML.load_file(filepath)
      bank_statements_array.each do |s|
        bs = BankStatement.new
        bs.statement_date = s['hash_data'][:statement_date]
        bs.beginning_balance = s['hash_data'][:beginning_balance]
        bs.ending_balance = s['hash_data'][:ending_balance]
        bs.reconciled_date = bs.statement_date.end_of_month + 1.day
        bs.book_id = book.id
        bs.save if save
      end
      return "statements"
    end

    def import_ofxes
      filepath = yaml_path + 'ofxes.yaml'
      ofxes_array = YAML.load_file(filepath)
      ofxes_array.each do |o|
        bs = BankStatement.find_by(statement_date: o['date'])
        if bs.present?
          bs.hash_data = o['hash_data']
          bs.ofx_data = o['text_data']
          bs.save if save
        end
      end
      return "ofxes"
    end

    def import_users
      filepath = yaml_path + 'users.yaml'
      users_array = YAML.load_file(filepath)
      User.create(users_array) if save
      return "users"
    end

  end

  class ExportYaml
    attr_accessor  :date, :yaml_path

    def initialize
      @yaml_path = Rails.root.join('../../Common/dumps')
    end

    def dump_all
      dump_accounts
      dump_entries
      dump_splits
      dump_deposits
      dump_sales_revenues
      dump_other_revenues
      dump_cash_out
      dump_ofxes
      dump_bank_statements
      dump_users
    end

    def dump_accounts
      filepath = yaml_path + 'accounts.yaml'
      yaml = ImportAccount.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_base_accounts
      filepath = yaml_path + 'base_accounts.yaml'
      yaml = ImportAccount.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end


    def dump_entries
      filepath = yaml_path + 'entries.yaml'
      yaml = ImportEntry.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_splits
      filepath = yaml_path + 'splits.yaml'
      yaml = ImportSplit.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    # Stash classes
    def dump_bank_statements
      filepath = yaml_path + 'bank_statements.yaml'
      yaml = BankStatement.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_ofxes
      filepath = yaml_path + 'ofxes.yaml'
      yaml = Ofx.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_users
      filepath = yaml_path + 'users.yaml'
      yaml = User.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_deposits
      filepath = yaml_path + 'deposits.yaml'
      yaml = Deposit.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end
    # revenue classes
    def dump_sales_revenues
      filepath = yaml_path + 'sales_revenues.yaml'
      yaml = SalesRevenue.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_other_revenues
      filepath = yaml_path + 'other_revenues.yaml'
      yaml = OtherRevenue.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

    def dump_cash_out
      filepath = yaml_path + 'cash_out.yaml'
      yaml = CashOut.all.order(:id).as_json.to_yaml
      File.write(filepath,yaml)
    end

  end

end