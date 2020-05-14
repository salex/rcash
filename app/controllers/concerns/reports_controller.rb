class ReportsController < ApplicationController
  before_action :require_book
  def index
    @acct_options  = @book.settings[:acct_sel_opt]

  end

  def destroy
    render plain: "This is a test and only a test. Delete link worked"
  end

  def profit_loss
    @report = Report.new.profit_loss({from:params[:from],to:params[:to],level:params[:level]})
    render  layout: 'print'
  end

  def trial_balance
    @report = Report.new.trial_balance
    render layout: 'print'
  end

  def summary
    if params[:account].blank?
      redirect_to reports_path, alert: 'Account was not selected'
    else
      set_param_date
      @summary  = Account.find(params[:account]).family_summary(@from,@to)
      if params[:combo].present?
        level = params[:level].present? ? params[:level] : 1
        @report = Report.new.profit_loss({from:@from,to:@to,level: level})
        render template:"reports/summarypl", layout: 'print'
      else
        render template:'reports/summary', layout: 'print'
      end
    end
  end

  def register_pdf
    set_param_date
    set_account
    pdf = RegisterPdf.new(@from,@account,@to)
    send_data pdf.render, filename: "CheckingRegister-#{params[:date]}",
      type: "application/pdf",
      disposition: "inline"
  end

  def split_register_pdf
    set_param_date
    set_account
    pdf = SplitRegisterPdf.new(@from,@account,@to)
    send_data pdf.render, filename: "SplitRegister-#{params[:date]}",
      type: "application/pdf",
      disposition: "inline"
  end

  def trustee_audit
    pdf = TrusteeAudit.new
    send_data pdf.render, filename: "trustee_audit",
      type: "application/pdf",
      disposition: "inline"
  end

  def audit
    # filepath = Rails.root.join("db/yaml","vfwcash.yaml")
    bolq = Date.today.beginning_of_quarter - 3.months
    eolq = bolq.end_of_quarter
    @range = bolq..eolq
    @config = Report.new.get_audit_config.to_o
    @summary = current_book.accounts.find_by(name:@config.current_assets).family_summary(@range.first,@range.last)
    render layout: 'print'
  end


  def checking_balance
    @checking_balance = Bank.new(params[:closing_date],params[:closing_balance]).checkbook_balance
  end

  def set_acct
    puts params.inspect
    session[:acct_id] = params[:id]
    head :ok
  end

  def test

    @banking = Bank.new
  end

  # def clear_splits
  #   entry = current_book.entries.find(params[:entry_id])
  #   splits = entry.splits.where(reconcile_state:'n')
  #   splits.update_all(reconcile_state:'c')
  #   @checking_balance = Bank.new(params[:closing_date],params[:closing_balance]).checkbook_balance
  #   # render partial:'reports/balance'

  # end

  # def unclear_splits
  #   entry = current_book.entries.find(params[:entry_id])
  #   splits = entry.splits.where(reconcile_state:'c')
  #   splits.update_all(reconcile_state:'n')
  #   @checking_balance = Bank.new(params[:closing_date],params[:closing_balance]).checkbook_balance
  #   # render partial:'reports/balance'
  # end

  def split_unclear
    entry = current_book.entries.find(params[:id])
    splits = entry.splits.where(reconcile_state:'c')
    splits.update_all(reconcile_state:'n')
    @checking_balance = Bank.new(params[:closing_date],params[:closing_balance]).checkbook_balance
    render partial:'reports/balance'
  end
  def split_clear
    entry = current_book.entries.find(params[:id])
    splits = entry.splits.where(reconcile_state:'n')
    splits.update_all(reconcile_state:'c')
    @checking_balance = Bank.new(params[:closing_date],params[:closing_balance]).checkbook_balance
    render partial:'reports/balance'
  end



  def custom
    set_param_date
    render plain: params
  end

  def edit_config
    # filepath = Rails.root.join("db/yaml","vfwcash.yaml")
    report = Report.new
    report.get_audit_config
    @vfwcashconfig = report.audit_yaml
  end

  def update_config
    yaml = params[:yaml].gsub(/\r\n?/, "\n")
   
    respond_to do |format|
      if  Report.new.put_audit_config(yaml)
        format.html { redirect_to  reports_path, notice: 'Audit Confiuration saved' }
      else
        format.html { render :edit_config }
      end
    end

  end


  private

  def require_book
    redirect_to(books_path, alert:'Current Book is required') if current_book.blank?
    @book = Current.book
  end

  def set_account
    @account = current_book.accounts.find_by(id:params[:account])
    redirect_to( accounts_path, alert:'Account not found for Current Book') if @account.blank?
  end

  
  def set_param_date
    if params[:date].present?
      @date = Ledger.set_date(params[:date])
      @from = @date.beginning_of_month
      @to = @date.end_of_month
    end
    if params[:from].present?
      @from = Ledger.set_date(params[:from])
    end
    if params[:to].present?
      @to = Ledger.set_date(params[:to])
    end
    if @from.blank?
      @date = Date.today
      @from = @date.beginning_of_year
      @to = @date.end_of_month
    end


  end



end