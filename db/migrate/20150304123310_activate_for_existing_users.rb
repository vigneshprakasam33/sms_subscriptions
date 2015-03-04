class ActivateForExistingUsers < ActiveRecord::Migration
  def change
    User.all.update_all(:activate => true)
  end
end
