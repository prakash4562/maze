class Task < ApplicationRecord
  after_create :log_task_details

  # Existing code ...

  def log_task_details
    TaskLoggerJob.perform_later(self)
  end
end
