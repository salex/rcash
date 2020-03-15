class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :open]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def open
    session[:book_id] = @book.id
    session[:tree_ids] = @book.settings[:tree_ids]
    session.delete(:recent)
    checking_account = @book.checking_acct
    leafs = checking_account.leaf.sort
    session[:recent]= {}
    session[:recent][checking_account.id.to_s] = checking_account.name
    sub_accts = Account.find(leafs)
    sub_accts.each do |l|
      session[:recent][l.id.to_s] = l.name
    end
    
    redirect_to accounts_path
  end

  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.create_book
        session[:book_id] = @book.id
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.settings = {skip:true}
    @book.destroy_book
    session.delete(:book_id)
    Current.book = nil
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
      if (session[:book_id] != @book.id) || @book.settings.blank?
        session[:book_id] = @book.id
        @book.get_settings
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :root, :assets, :equity, :liabilities, :income, :expenses, :checking, :savings, :settings)
    end
end
