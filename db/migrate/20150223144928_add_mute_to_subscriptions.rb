class AddMuteToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :mute, :boolean , default: false
  end
end
