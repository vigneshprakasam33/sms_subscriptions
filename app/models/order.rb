class Order < ActiveRecord::Base
  has_many :subscriptions
  belongs_to :user

  def purchase
    response = process_purchase
    response.success?
  end


  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end

  def process_purchase
    if !express_token.blank?
      logger.debug "=======>invoking purchase"
      #in cents
      EXPRESS_GATEWAY.purchase(self.price.to_f * 100, express_purchase_options)
    end
  end

  def express_purchase_options
    {
        :token => express_token,
        :payer_id => express_payer_id
    }
  end


end
