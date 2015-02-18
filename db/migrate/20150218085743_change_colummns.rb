class ChangeColummns < ActiveRecord::Migration
  def change
    add_column :subscriptions , :category_id , :integer
    rename_column :messages , :category , :category_id
    change_column :messages, :category_id , :integer
  end
end
