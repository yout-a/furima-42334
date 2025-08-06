class AddPriceToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :price, :integer
  end
end
