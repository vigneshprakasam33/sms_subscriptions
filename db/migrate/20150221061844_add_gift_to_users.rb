class AddGiftToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gift, :boolean , :default => false
  end
end
