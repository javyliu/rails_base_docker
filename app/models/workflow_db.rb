class WorkflowDb < ActiveRecord::Base
  self.abstract_class = true
  #connects_to database: {}
  establish_connection :workflow
end
