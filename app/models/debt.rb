class Debt < ActiveRecord::Base
  include Workflow
  has_paper_trail

  validates_presence_of [:description, :amount, :person, :business_unit]
  attr_protected :workflow_state
  attr_readonly :person_id, :person

  belongs_to :person
  belongs_to :business_unit

  validate :locked_when_finalized

  scope :unpaid, where(workflow_state: %w(new bookkept))

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
      event :cancel, transitions_to: :anulled
      event :pay, transitions_to: :paid
      event :keep, transitions_to: :bookkept
    end
    # paid but not bookkept
    state :paid do
      event :keep, transitions_to: :finalized
    end
    # bookkept but not paid
    state :bookkept do
      event :pay, transitions_to: :finalized
    end
    # both bookkept and paid
    state :finalized
    # cancelled (duh)
    state :anulled
  end

  def cancel
    notify_observers(:after_cancel)
  end

  def pay
    notify_observers(:after_pay)
  end

  def locked_when_finalized
    errors.add(:base, I18n.t('activerecord.errors.models.debt.finalized_cannot_be_edited')) if finalized?
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

  def author
    Person.find(versions.first.whodunnit.to_i)
  end

  def last_updated_by
    Person.find(originator.to_i)
  end
end
