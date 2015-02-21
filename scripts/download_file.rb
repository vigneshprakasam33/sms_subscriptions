
require 'open-uri'

File.open("sample", "wb") do |saved_file|
  # the following "open" is provided by open-uri
  open("http://api.twilio.com/2010-04-01/Accounts/ACc9f80c975d0574058948613554ca5adf/Recordings/REfda2ad7b6076b1c7c1881e0db5161981", "rb") do |read_file|
    saved_file.write(read_file.read)
  end
end


