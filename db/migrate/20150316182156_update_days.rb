class UpdateDays < ActiveRecord::Migration
  def change
    PriceConfig.find_by_days(120).update(:days => 90)
  end
end
