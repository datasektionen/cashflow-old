class Debt < ActiveRecord::Base
  include Workflow
  has_paper_trail
  
  validates_presence_of [:description, :amount, :person, :author, :business_unit]
  attr_protected :workflow_state
  
  belongs_to :person
  belongs_to :author, :class_name => "Person", :foreign_key => "created_by"
  belongs_to :business_unit
  
  workflow do
    state :new do
      event :cancel, :transitions_to => :cancelled
      event :pay, :transitions_to => :paid
    end
    state :paid
    state :cancelled
  end
end
