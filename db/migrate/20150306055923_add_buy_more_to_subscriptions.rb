class AddBuyMoreToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :buy_more, :boolean
  end
end
