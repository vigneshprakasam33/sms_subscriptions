class Support < ActiveRecord::Base
  validates_presence_of :email , :content
end
