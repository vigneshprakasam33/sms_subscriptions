class CreateConfigMessages < ActiveRecord::Migration
  def change
    create_table :config_messages do |t|
      t.integer :user_id
      t.text :content
      t.string :type

      t.timestamps
    end
  end
end
