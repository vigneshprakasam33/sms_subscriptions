class Job < ActiveRecord::Base
  belongs_to :subscription
  after_destroy :destroy_dj

  #delete the enqueued job
  def destroy_dj
    dj = Delayed::Job.find_by_id(self.delayed_job_id)
    if dj
      dj.delete
    end
  end

end
