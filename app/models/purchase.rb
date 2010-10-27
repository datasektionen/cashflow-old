class Purchase < ActiveRecord::Base
  include Workflow
  has_paper_trail
  
  belongs_to :person
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "Person", :foreign_key => "updated_by_id"
  belongs_to :business_unit
  
  validates_presence_of :person, :created_by, :updated_by, :business_unit, :description, :purchased_at
  
  validate :cannot_purchase_stuff_in_the_future
  
  attr_readonly :person, :person_id
  
  # workflow for Purchase model
  #                                   :keep --> (bookkept) -- :pay --
  #                                /                                  \
  #        :confirm --> (confirmed)                                    \
  #      /              ^    \     \                                    v
  # (new)          :confirm  :edit   :pay   --> (paid) -- :keep --> (finalized)
  #   \ \               \    v
  #    \ :edit     --> (edited)
  #     \
  #      \
  #        :cancel -->  (cancelled)
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
  
  protected
  
  def cannot_purchase_stuff_in_the_future
    if !self.purchased_at.blank? && self.purchased_at > Date.today
      errors.add(:base, "Du kan inte ha köpt in något i framtiden. Har du uppfunnit en tidsmaskin får du gärna kontakta mig på frost@ceri.se.")
      errors.add(:purchased_at, "får inte vara senare än dagens datum")
    end
  end
end
