class AddTempBuyMorePriceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :temp_buy_more, :string
  end
end
