class AddAdmin < ActiveRecord::Migration
  def change
    User.create(:name => "Admin" , :surname => "Admin" , :is_admin => true , :phone => "1234567890" , :password => "MotoX",:time_zone => "Chennai")
  end
end
