class AccountsController < ApplicationController
  before_action :require_book
  before_action :set_account, only: [:show, :edit, :update, :destroy,:set_recent]
  before_action :session_tree, only: [:update,:create,:destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_book.accounts.find(tree_ids)
    # render :index_table
  end

  def index_table
    @accounts = current_book.accounts.find(tree_ids)
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    set_recent if params[:toggle].present?
    @date = Date.today
    set_param_date
    session[:current_acct] = @account.id
  end

  # GET /accounts/new
  def new
    @parent = current_book.accounts.find_by(id:params[:parent_id])
    @account = current_book.accounts.new(uuid:SecureRandom.uuid,parent_id:@parent.id,level:@parent.level+1)
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = current_book.accounts.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_recent
    if session[:recent] && session[:recent].has_key?(@account.id.to_s)
      session[:recent].delete(@account.id.to_s) 
    else
      session[:recent][@account.id.to_s] = @account.name
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



  private
    def require_book
      redirect_to(books_path, alert:'Current Book is required') if current_book.blank?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_param_date
      @today = Date.today
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
    end

    def session_tree
      session.delete(:tree_ids)
    end

    def set_account
      @account = current_book.accounts.find_by(id:params[:id])
      redirect_to( accounts_path, alert:'Account not found for Current Book') if @account.blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:uuid, :book_id, :name, :account_type, :code, :description, :placeholder, :contra, :parent_id, :level)
    end
end
