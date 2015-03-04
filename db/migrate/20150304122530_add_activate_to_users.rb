class AddActivateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activate, :boolean , default: false
  end
end
