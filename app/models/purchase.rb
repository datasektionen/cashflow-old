class Purchase < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  has_paper_trail
  include Workflow

  belongs_to :person
  # belongs_to :last_modified_by, foreign_key: :originator, class_name: "Person"
  belongs_to :budget_post

  before_create :check_budget_rows_exists
  before_validation :set_year

  has_many :items, class_name: "PurchaseItem", dependent: :destroy

  validates_presence_of :person_id, :description, :purchased_on, :budget_post

  validate :cannot_purchase_stuff_in_the_future, :locked_when_finalized

  attr_readonly :person, :person_id

  delegate :business_unit, to: :budget_post
  delegate :business_unit_id, to: :budget_post

  before_validation :generate_slug
  after_save :generate_slug

  accepts_nested_attributes_for :items, allow_destroy: true

  def self.searchable_language
    "swedish"
  end

  scope :unpaid, -> { where(workflow_state: %w(new edited confirmed bookkept)) }
  scope :confirmed, -> { where(workflow_state: %w(confirmed edited)) }
  scope :keepable, -> { where(workflow_state: :paid) }
  scope :accepted, -> {
    where(workflow_state: %w(confirmed bookkept paid finalized))
  }
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
  states = {
    new:        { confirm: :confirmed, cancel: :cancelled, edit: :edited },
    edited:     { confirm: :confirmed, cancel: :cancelled },
    confirmed:  { edit: :edited, pay: :paid, keep: :bookkept },
    paid:       { keep: :finalized },
    bookkept:   { pay: :finalized },
    finalized:  {},
    cancelled:  {}
  }

  workflow do
    states.each do |current, transitions|
      state current do
        transitions.each do |trigger, new_state|
          event trigger, transitions_to: new_state
        end
      end
    end
  end

  def total
    items.sum(:amount)
  end

  # Check whether a purchase is editable
  # A purchase is editable if it's "new", "edited" or "confirmed"
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
    versions.drop(1).reverse.map do |version|
      OpenStruct.new(version_date: version.created_at,
                     workflow_state: version.reify.workflow_state,
                     originator: version.whodunnit.to_i)
    end
  end

  # Returns the last person to confirm this purchase (if any)
  def confirmed_by
    return Person.find(originator) if confirmed?
    s = state_history.find { |state| state.workflow_state == "confirmed" }
    if s
      Person.find(s.originator)
    end
  end

  def confirmed_by_id
    return originator if confirmed?
    s = state_history.find { |state| state.workflow_state == "confirmed" }
    s.originator if s
  end

  def last_updated_by
    Person.find(originator.to_i)
  end

  protected

  def cannot_purchase_stuff_in_the_future
    if !purchased_on.blank? && purchased_on > Date.today
      translation_base = "activerecord.errors.models.purchase"
      errors.add(:base, I18n.t("#{translation_base}.purchased_in_future"))
      purchased_on_error =
        "#{translation_base}.attributes.purchased_on.purchased_in_future"
      errors.add(:purchased_on, I18n.t(purchased_on_error))
    end
  end

  def locked_when_finalized
    if finalized?
      errors.add(:base, I18n.t("activerecord.errors.models.purchase.finalized"))
    end
  end

  def generate_slug
    if new_record?
      self.slug = "temp-slug-#{Time.now}"
      return true
    end

    slug = "%s%d-%d" % [business_unit.try(:short_name), year.to_i, id]

    if self.slug !~ /#{slug}/
      Purchase.paper_trail_off!
      update_column(:slug, slug)
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
    grouped.reduce({}) { |hash, (k, v)| hash.merge(k => v.sum(&:total)) }
  end

  def self.pay_multiple!(params)
    people_ids = params[:pay].map { |k, v| k if v.to_i == 1 }
    purchases = Purchase.where(person_id: people_ids).payable

    purchases.map(&:pay!)

    purchases.map(&:id)
  end

  def self.states_collection
    workflow_spec.states.map { |s|
      name = s.first.to_s
      [name, I18n.t("workflow_state.#{name}")]
    }
  end
end
