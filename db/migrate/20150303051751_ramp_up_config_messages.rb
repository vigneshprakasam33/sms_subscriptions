class RampUpConfigMessages < ActiveRecord::Migration
  def change
    user_id = User.where(:is_admin => true).first.id
    ConfigMessage.create(:user_id => user_id , :message_type=> "welcome" ,:content => "Welcome to the Affirmation service. Congratulations on taking action. To mute or change delivery time, login at http://realmobile.se/signin . Your user name is <phone_number> and password is <password>.")
    ConfigMessage.create(:user_id => user_id , :message_type=> "welcome_gift" ,:content => "Dear <name>, You’ve been given a gift for an sms affirmation service. Login at http://realmobile.se/signin . Your user name is <phone_number> and password is <password>. To accept, do nothing. To reject reply: REJECT")
    ConfigMessage.create(:user_id => user_id , :message_type=> "renewal" ,:content => "Your affirmation service is about to expire in 3 days. To renew, please login at http://realmobile.se/signin and click 'Buy More'")
    ConfigMessage.create(:user_id => user_id , :message_type=> "expiry" ,:content => "Your affirmation service has expired. To renew, please login at http://realmobile.se/signin and click 'Buy More'")
  end
end
