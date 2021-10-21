json.extract! transaction, :id, :name, :amount, :date, :category, :description, :liper, :ioe, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
