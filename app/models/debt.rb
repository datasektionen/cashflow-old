class Debt < ActiveRecord::Base
  include Workflow

  validates_presence_of [:description, :amount, :person, :author, :business_unit]
  attr_protected :workflow_state
  
  belongs_to :person
  belongs_to :author, :class_name => "Person", :foreign_key => "created_by"
  belongs_to :business_unit
  
  workflow do
    state :new do
      event :cancel, :transitions_to => :cancelled
      # event :confirm, :transitions_to => :confirmed
    end
    
    state :cancelled
    
  end
end
