class AddMessagesCountToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :messages_count, :integer , default: 0
  end
end
