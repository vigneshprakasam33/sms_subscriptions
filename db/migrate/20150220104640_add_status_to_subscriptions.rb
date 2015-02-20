class AddStatusToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :status, :string , default: "active"
  end
end
