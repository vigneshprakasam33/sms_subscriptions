class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :message
  belongs_to :category

  attr_accessor :message_category


  def send_message(text,number)
    #$account_sid = 'AC464e95aa436faa83c989a5140d8a0b66'
    #$auth_token = 'a49866d0a744d8642da934997ce71f78'

    #mine
    $account_sid = 'ACc9f80c975d0574058948613554ca5adf'
    $auth_token = '4dc2192cd7088ed3728b9899ff3b15bf'

    logger.debug  $account_sid
    client =Twilio::REST::Client.new $account_sid, $auth_token
    client.account.messages.create(:from => "" , :body => text , :to => number)
  end

end
