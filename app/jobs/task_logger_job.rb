class TaskLoggerJob < ApplicationJob
  queue_as :default

  def perform(file)
    User.import(file)
  end

end
