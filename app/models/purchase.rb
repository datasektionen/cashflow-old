class Purchase < ActiveRecord::Base
  include Workflow
  has_paper_trail
  
  belongs_to :person
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "Person", :foreign_key => "updated_by_id"
  belongs_to :business_unit

  has_many :items, :class_name => "PurchaseItem", :dependent => :destroy
  
  validates_presence_of :person, :created_by, :updated_by, :business_unit, :description, :purchased_at
  
  validate :cannot_purchase_stuff_in_the_future, :locked_when_finalized
  
  attr_readonly :person, :person_id
  
  accepts_nested_attributes_for :items
  
  scope :unpaid, where(:workflow_state => %w[new edited confirmed bookkept])
  
  # workflow for Purchase model
  #                                   :keep --> (bookkept) -- :pay --
  #                                /                                  \
  #        :confirm --> (confirmed)                                    \
  #      /              ^    \     \                                    v
  # (new)          :confirm  :edit   :pay   --> (paid) -- :keep --> (finalized)
  #   \ \               \    v
  #    \ :edit     --> (edited)
  #     \                   \
  #      \                   \
  #       ------------------> :cancel -->  (cancelled)
  # 
  workflow do
    state :new do
      event :confirm, :transitions_to => :confirmed
      event :cancel, :transitions_to => :cancelled
      event :edit, :transitions_to => :edited
    end
    
    
    state :edited do
      event :cancel, :transitions_to => :cancelled
      event :confirm, :transitions_to => :confirmed
    end
    
    state :confirmed do
      event :edit, :transitions_to => :edited
      event :pay, :transitions_to => :paid
      event :keep, :transitions_to => :bookkept
    end
    
    state :paid do
      event :keep, :transitions_to => :finalized
    end
    
    state :bookkept do
      event :pay, :transitions_to => :finalized
    end
    
    state :finalized
    
    state :cancelled
  end

  # calculate total amount for purchase items
  def total
    items.inject(0) {|sum,i| sum += i.amount }
  end
  

  def name
    "%s-%d" % [self.person.to_param, self.id]
  end

  # Check whether a purchase is editable
  # A purchase is editable if it's in any of the "new", "edited" or "confirmed" states.
  def editable?
    ["new", "edited", "confirmed"].include?(self.workflow_state)
  end

  # Check whether a purchase is bookkeepable
  def keepable?
    ["confirmed", "payed"].include?(self.workflow_state)
  end

  # Check whether a purchase is payable
  def payable?
    ["confirmed", "bookkept"].include?(self.workflow_state)
  end

  protected
  
  def cannot_purchase_stuff_in_the_future
    if !self.purchased_at.blank? && self.purchased_at > Date.today
      errors.add(:base, "Du kan inte ha köpt in något i framtiden. Har du uppfunnit en tidsmaskin får du gärna kontakta mig på frost@ceri.se.")
      errors.add(:purchased_at, "får inte vara senare än dagens datum")
    end
  end
  
  def locked_when_finalized
    errors.add(:base, "Du kan inte ändra ett avslutat inköp") if finalized?
  end
end
