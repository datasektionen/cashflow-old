class Purchase < ActiveRecord::Base
  include Workflow
  has_paper_trail
  has_friendly_id :slug

  belongs_to :person
  belongs_to :budget_post

  before_create :check_budget_rows_exists
  before_validation :set_year

  has_many :items, class_name: 'PurchaseItem', dependent: :destroy

  validates_presence_of :person_id, :description, :purchased_on, :budget_post

  validate :cannot_purchase_stuff_in_the_future, :locked_when_finalized

  attr_readonly :person, :person_id

  delegate :business_unit, to: :budget_post
  delegate :business_unit_id, to: :budget_post

  before_validation :generate_slug
  after_save :generate_slug

  accepts_nested_attributes_for :items, allow_destroy: true

  searchable do
    string :workflow_state
    integer :person_id, references: Person
    integer :business_unit_id

    date :purchased_on
    date :updated_at
    text :description
    float :total
  end

  scope :unpaid, -> { where(workflow_state: %w(new edited confirmed bookkept)) }
  scope :confirmed, -> { where(workflow_state: %w(confirmed edited)) }
  scope :keepable, -> { where(workflow_state: :paid) }
  scope :accepted, -> { where(workflow_state: %w(confirmed bookkept paid finalized)) }
  scope :payable, -> { where(workflow_state: %w(confirmed bookkept)) }

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
      event :confirm, transitions_to: :confirmed
      event :cancel, transitions_to: :cancelled
      event :edit, transitions_to: :edited
    end

    state :edited do
      event :cancel, transitions_to: :cancelled
      event :confirm, transitions_to: :confirmed
    end

    state :confirmed do
      event :edit, transitions_to: :edited
      event :pay, transitions_to: :paid
      event :keep, transitions_to: :bookkept
    end

    state :paid do
      event :keep, transitions_to: :finalized
    end

    state :bookkept do
      event :pay, transitions_to: :finalized
    end

    state :finalized

    state :cancelled
  end

  def confirm
    notify_observers(:after_confirm)
  end

  def keep
    notify_observers(:after_keep)
  end

  def pay
    notify_observers(:after_pay)
  end

  def cancel
    notify_observers(:after_cancel)
  end

  # calculate total amount for purchase items
  def total
    items.sum(:amount)
  end

  # Check whether a purchase is editable
  # A purchase is editable if it's in any of the "new", "edited" or "confirmed" states.
  def editable?
    %w(new edited confirmed).include?(workflow_state)
  end

  # Check whether a purchase is bookkeepable
  def keepable?
    %w(confirmed paid).include?(workflow_state)
  end

  def budget_row
    BudgetRow.find_by_budget_post_id_and_year(budget_post_id, year)
  end

  # Check whether a purchase is payable
  def payable?
    %w(confirmed bookkept).include?(workflow_state)
  end

  def state_history
    states = []
    version = self
    until version.nil?
      whodunnit = version.version && version.version.previous ? Person.find(version.version.previous.whodunnit.to_i) : version.last_updated_by
      states << OpenStruct.new(version_date: version.updated_at, workflow_state: version.workflow_state, originator: whodunnit)
      version = version.previous_version
    end
    states
  end

  # Returns the last person to confirm this purchase (if any)
  def confirmed_by
    s = state_history.find { |state| state.workflow_state == 'confirmed' }
    s.originator if s
  end

  def last_updated_by
    Person.find(originator.to_i)
  end

  protected

  def cannot_purchase_stuff_in_the_future
    if !purchased_on.blank? && purchased_on > Date.today
      errors.add(:base, I18n.t('activerecord.errors.models.purchase.purchased_in_future'))
      errors.add(:purchased_on, I18n.t('activerecord.errors.models.purchase.attributes.purchased_on.purchased_in_future'))
    end
  end

  def locked_when_finalized
    errors.add(:base, I18n.t('activerecord.errors.models.purchase.finalized')) if finalized?
  end

  def generate_slug
    if new_record?
      self.slug = "temp-slug-#{Time.now}"
      return true
    end

    slug = '%s%d-%d' % [business_unit.try(:short_name), year.to_i, id]

    if self.slug !~ /#{slug}/
      Purchase.paper_trail_off!
      update_attribute(:slug, slug)
      Purchase.paper_trail_on!
    end
  end

  def set_year
    self.year = purchased_on.try(:year) || Time.now.year
  end

  def check_budget_rows_exists
    unless BudgetRow.find_by_year(year)
      BudgetRow.create_rows_if_not_exists(year)
    end
  end

  def self.payable_grouped_by_person
    grouped = Purchase.payable.group_by(&:person)
    grouped.reduce({}) {|hash, (key, val)| hash.merge(key => val.sum(&:total))}
  end

  def self.pay_multiple!(params)
    people_ids = params[:pay].collect { |k, v| k if v.to_i == 1 }
    purchases = Purchase.where(person_id: people_ids).payable

    purchases.map(&:pay!)

    purchases.map(&:id)
  end
end
