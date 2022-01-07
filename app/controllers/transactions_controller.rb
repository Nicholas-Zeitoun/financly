class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
    @personal_transactions = Transaction.all.select { |m| m.liper == "personal" }
    @living_transactions = Transaction.all.select { |m| m.liper == "living" }
    @income_transactions = Transaction.all.select { |m| m.ioe == "income" }
  end

  def tracking
    @transactions = Transaction.all
    @personal_transactions = Transaction.all.select { |m| m.liper == "personal" }
    @living_transactions = Transaction.all.select { |m| m.liper == "living" }
    @income_transactions = Transaction.all.select { |m| m.ioe == "income" }

    @expenses = 0
    @living_expenses = 0
    @personal_expenses = 0
    @income = 0
    @transactions.each do |transaction|
      if transaction.ioe == "expense"
        case transaction.liper
        when "personal"
          @personal_expenses += transaction.amount
        when "living"
          @living_expenses += transaction.amount
        else
          # @expenses += transaction.amount
        end
        @expenses = (@personal_expenses + @living_expenses)
      else
        @income += transaction.amount
      end
    end
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        @transaction = Transaction.new
        # format.html { render 'transactions/new', notice: "Transaction was successfully created." }
        format.html { redirect_to new_transaction_path, notice: "Transaction was successfully created." }
        # format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:name, :amount, :date, :category, :description, :liper, :ioe)
    end
end
