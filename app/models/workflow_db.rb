class WorkflowDb < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: {writing: :workflow }
  #establish_connection :workflow
end
