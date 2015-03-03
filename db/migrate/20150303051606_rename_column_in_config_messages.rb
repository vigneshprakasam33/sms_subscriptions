class RenameColumnInConfigMessages < ActiveRecord::Migration
  def change
    rename_column :config_messages , :type , :message_type
  end
end
