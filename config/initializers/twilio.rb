require 'twilio-ruby'

# put your own credentials here
$sms_from = "441172001588"
$account_sid = 'AC464e95aa436faa83c989a5140d8a0b66'
$auth_token = 'a49866d0a744d8642da934997ce71f78'
#$click_to_call_app = 'AP98ca75b453141603fa76d7db706ac12e'

# set up a client to talk to the Twilio REST API
$twilio_client = Twilio::REST::Client.new $account_sid, $auth_token
