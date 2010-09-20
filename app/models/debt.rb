class Debt < ActiveRecord::Base
  validates_presence_of [:description, :workflow_state, :amount, :person, :author, :business_unit]
  attr_protected :workflow_state
  
  belongs_to :person
  belongs_to :author, :class_name => "Person", :foreign_key => "created_by"
  belongs_to :business_unit
end
