class AddPrice < ActiveRecord::Migration
  def change
    PriceConfig.create(:days => 30 , :price => "2.00")
    PriceConfig.create(:days => 60 , :price => "4.00")
    PriceConfig.create(:days => 120 , :price => "8.00")
  end
end
