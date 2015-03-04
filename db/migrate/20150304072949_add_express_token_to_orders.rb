class AddExpressTokenToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :express_token, :string
    add_column :orders, :express_payer_id, :string
    add_column :orders, :user_id, :integer
  end
end
