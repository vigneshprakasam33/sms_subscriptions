class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :order_id
      t.text :subscription_message
      t.integer :message_id
      t.integer :frequency
      t.datetime :delivery_time
      t.boolean :gift

      t.timestamps
    end
  end
end
