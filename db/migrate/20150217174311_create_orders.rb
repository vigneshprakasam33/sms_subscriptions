class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :payment_method
      t.string :price
      t.string :status

      t.timestamps
    end
  end
end
