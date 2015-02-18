class ChangeColumnDeliveryTime < ActiveRecord::Migration
  def change
    change_column :subscriptions , :delivery_time , :string
  end
end
