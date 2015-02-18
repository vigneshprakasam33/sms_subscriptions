class Message < ActiveRecord::Base
  belongs_to :category
  alias_attribute :name, :content

end
