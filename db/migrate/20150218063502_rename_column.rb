class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :subscriptions , :frequency , :duration
  end
end
