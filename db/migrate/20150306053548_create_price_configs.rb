class CreatePriceConfigs < ActiveRecord::Migration
  def change
    create_table :price_configs do |t|
      t.integer :days
      t.string :price

      t.timestamps
    end
  end
end
