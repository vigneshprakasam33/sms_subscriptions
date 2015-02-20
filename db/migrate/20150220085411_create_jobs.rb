class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :subscription_id
      t.datetime :execution_time
      t.integer :delayed_job_id
      t.string :status
      t.string :message
      t.string :recipient_number

      t.timestamps
    end
  end
end
