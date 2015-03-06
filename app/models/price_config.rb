class PriceConfig < ActiveRecord::Base

  def self.pricing(days)
    p = PriceConfig.find_by_days(days.to_i)
    p.price.to_i if p
  end
end
