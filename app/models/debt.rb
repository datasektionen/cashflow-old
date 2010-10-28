class Debt < ActiveRecord::Base
  include Workflow
  has_paper_trail
  
  validates_presence_of [:description, :amount, :person, :author, :business_unit]
  attr_protected :workflow_state
  attr_readonly :person_id, :person
  
  belongs_to :person
  belongs_to :author, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :business_unit

  validate :locked_when_finalized

  # workflow for the Debt model:
  # 
  #         :pay --> (paid) -- :keep --> (finalized)
  #       /                                 /
  #  (new) -- :keep --> (bookkept) -- :pay
  #      \
  #        :cancel --> (cancelled)
  # 
  workflow do
    # default state
    state :new do
      event :cancel, :transitions_to => :cancelled
      event :pay, :transitions_to => :paid
      event :keep, :transitions_to => :bookkept
    end
    # paid but not bookkept
    state :paid do
      event :keep, :transitions_to => :finalized
    end
    # bookkept but not paid
    state :bookkept do
      event :pay, :transitions_to => :finalized
    end
    # both bookkept and paid
    state :finalized
    # cancelled (duh)
    state :cancelled
  end
  
  def locked_when_finalized
    errors.add(:base, "Du kan inte redigera en avslutad skuld") if finalized?
  end
end
