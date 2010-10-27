class Purchase < ActiveRecord::Base
  include Workflow
  has_paper_trail
  
  belongs_to :person
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "Person", :foreign_key => "updated_by_id"
  belongs_to :business_unit
  
  validates_presence_of :person, :created_by, :updated_by, :business_unit
  
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
end
