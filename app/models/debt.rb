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
  
  scope :unpaid, where(:workflow_state => %w[new bookkept])

  # workflow for the Debt model:
  # 
  #         :pay --> (paid) -- :keep --> (finalized)
  #       /                                 /
  #  (new) -- :keep --> (bookkept) -- :pay
  #      \
  #        :cancel --> (anulled)
  # 
  workflow do
    # default state
    state :new do
      event :cancel, :transitions_to => :anulled
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
    state :anulled
  end
  
  def locked_when_finalized
    errors.add(:base, "Du kan inte redigera en avslutad skuld") if finalized?
  end

  def cancellable?
    self.new?
  end

  def payable?
    self.new? || self.bookkept?
  end

  def keepable?
    self.new? || self.paid?
  end

end
