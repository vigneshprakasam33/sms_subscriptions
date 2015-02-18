class Message < ActiveRecord::Base
  alias_attribute :name, :content
end
