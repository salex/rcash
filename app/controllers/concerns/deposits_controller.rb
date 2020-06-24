class DepositsController < ApplicationController
  before_action :set_deposit, only: [:show, :edit, :update, :destroy, :edit_other, :update_other]

  # GET /deposits
  # GET /deposits.json
  def index
    @deposits = Deposit.order(date: :desc)
  end

  def weekly
    eow = Date.today.end_of_week
    unless Deposit.find_by(date:eow).present?
      Deposit.create(date:eow)
    end
    @deposits = Deposit.order(:date).reverse_order.limit(6)
  end


  # GET /deposits/1
  # GET /deposits/1.json
  def show
  end

  def month_summary
    if params[:date].present?
      bom = Date.parse(params[:date]).beginning_of_month
    else
      bom = Date.today.beginning_of_month
    end
    eom = bom.end_of_month
    @deposits = Deposit.where(date:bom..eom).order(:date)
  end

  # GET /deposits/new
  def new
    @deposit = Deposit.new
    edit
    # Deposit::RevenueClasses.each do |r|
    #   @deposit.sales_revenues.build(item:r)
    # end
    # @deposit.cash_outs.build(item:'CashOut')
  end

  # GET /deposits/1/edit
  def edit
    if @deposit.sales_revenues.blank?
      Deposit::RevenueClasses.each do |r|
        @deposit.sales_revenues.build(item:r)
      end
    end
    if @deposit.cash_outs.blank?
      @deposit.cash_outs.build(item:'CashOut')
    end
  end

  def edit_other
    dcount = @deposit.other_revenues.count
    cnt = dcount.zero? ? 6 : 2
    cnt.times do
      @deposit.other_revenues.build
    end
  end

  # def beer_edit
  #   @inv = Inventory.last
  #   # @inv.get_qoh
  #   @inv.beer
  #   render layout:'printable'
  # end

  # def liquor_edit
  #   @inv = Inventory.last
  #   @inv.liquor
  #   render layout:'printable'

  # end

  # def liquor_update
  #   @inv = Inventory.last

  #   results = @inv.update_liquor(liquor_params)
  #   redirect_to weekly_deposits_path, notice:'Liquor inventory updated'
  # end

  # def beer_update
  #   @inv = Inventory.last
  #   results = @inv.update_beer(beer_params)
  #   redirect_to weekly_deposits_path, notice:'Beer inventory updated'
  # end

  def update_other
    respond_to do |format|
      if @deposit.update(deposit_params) && @deposit.update_other(deposit_params)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end

  end

  # def upload_qoh
  # end

  # def update_qoh
  #   qoh_path = Rails.root.join('yaml/inventory/qoh.csv')
  #   io =  params[:text_field]
  #   e = io.read
  #   csv = e.force_encoding("UTF-8")
  #   inv = Inventory.last
  #   inv.csv = csv
  #   inv.save
  #   redirect_to weekly_deposits_path, notice:'Quanity on Hand updated' 
  #   # render plain: io
  # end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deposits/1
  # PATCH/PUT /deposits/1.json
  def update
    respond_to do |format|
      if @deposit.update(deposit_params) && @deposit.update_other(deposit_params)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      @deposit = Deposit.find(params[:id])
    end

    # def liquor_params
    #   params.permit!.to_h
    # end

    # def beer_params
    #   params.permit!.to_h
    # end


    # Never trust parameters from the scary internet, only allow the white list through.
    def deposit_params
      params.require(:deposit).permit(:date, :sales_revenue, :other_revenue, :cash_sales, :credit_sales, 
        :tips_paid, :sales_deposit, :other_deposit, :total_deposit, :cash_out,
        other_revenues_attributes:[:id,:_destroy,:type,:item,:amount,:remarks],
        sales_revenues_attributes:[:id,:item,:quanity,:amount],
        cash_outs_attributes:[:id,:item,:remarks,:amount])
    end
end
