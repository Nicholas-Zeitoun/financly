class AddDarkmodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :darkmode, :boolean
  end
end
