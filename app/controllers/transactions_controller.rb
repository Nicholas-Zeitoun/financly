class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.order('date DESC')
    @personal_transactions = Transaction.order('date DESC').select { |m| m.liper == "personal" }
    @living_transactions = Transaction.order('date DESC').select { |m| m.liper == "living" }
    @income_transactions = Transaction.order('date DESC').select { |m| m.ioe == "income" }
  end

  def tracking
    @transactions = Transaction.all
    @ordered_transactions = Transaction.order('date DESC')
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

    # Monthly Stuff
    @monthly = @transactions.group_by_month(:date).count
    t_index = 0
    @monthly_transactions = {}
    @monthly.reverse_each do |key, value|
      @monthly_expenses = []
      @monthly_income = []
      @ioe = []
      value.times do
        case @ordered_transactions[t_index].ioe
        when 'income'
          @monthly_income.push(@ordered_transactions[t_index])
        when 'expense'
          @monthly_expenses.push(@ordered_transactions[t_index])
        end
        t_index += 1
      end
      @ioe.push(@monthly_expenses).push(@monthly_income)
      @monthly_transactions[key] = @ioe
    end

    # Yearly Stuff
    @yearly = @transactions.group_by_year(:date).count
    y_index = 0
    @yearly_transactions = {}
    @yearly.reverse_each do |key, value|
      @yearly_expenses = []
      @yearly_income = []
      @yearly_expenses_total = 0
      @yearly_income_total = 0
      @yioe = []
      value.times do
        case @ordered_transactions[y_index].ioe
        when 'income'
          @yearly_income.push(@ordered_transactions[y_index])
          @yearly_income_total += @ordered_transactions[y_index].amount
        when 'expense'
          @yearly_expenses.push(@ordered_transactions[y_index])
          @yearly_expenses_total += @ordered_transactions[y_index].amount
        end
        y_index += 1
      end
      @yioe.push(@yearly_expenses).push(@yearly_income)
      @yioe.push(@yearly_income_total).push(@yearly_expenses_total)
      @yearly_transactions[key] = @yioe
    end

    # Category stuff
    @categorized_expenses = Hash.new {|h,k| h[k] = [] }
    @categorized_income = Hash.new {|h,k| h[k] = [] }
    @transactions.each do |transaction|
      case transaction.ioe
      when 'income'
        @categorized_income[transaction.category].push(transaction)
      when 'expense'
        @categorized_expenses[transaction.category].push(transaction)
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
