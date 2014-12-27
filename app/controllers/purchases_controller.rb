class PurchasesController < ApplicationController
  load_and_authorize_resource except: [:confirmed, :pay_multiple]
  before_filter :get_items, only: [:show, :edit, :update, :destroy]

  expose(:budget_posts) { BudgetPost.includes(:business_unit).all }

  def index
    @search = Purchase.joins(:budget_post).joins(:person).includes(:person).search do
      with(:workflow_state, filter_param(:workflow_state)) unless filter_param(:workflow_state).blank?
      with(:person_id, filter_param(:person_id)) unless filter_param(:person_id).blank?
      with(:business_unit_id, filter_param(:business_unit_id)) unless filter_param(:business_unit_id).blank?

      with(:purchased_on).greater_than(filter_param :purchased_on_from) unless filter_param(:purchased_on_from).blank?
      with(:purchased_on).less_than(filter_param :purchased_on_to) unless filter_param(:purchased_on_to).blank?

      with(:updated_at).greater_than(filter_param :updated_at_from) unless filter_param(:updated_at_from).blank?
      with(:updated_at).less_than(filter_param :updated_at_to) unless filter_param(:updated_at_to).blank?

      paginate page: params[:page]
    end
    @purchases = @search.results
  end

  def show
  end

  def new
    @purchase = current_user.purchases.new
    @purchase.items.build
  end

  def edit
  end

  def create
    @purchase = @current_user.purchases.new(params[:purchase])

    if @purchase.person_id != current_user.id
      authorize! :edit, :purchase_owner
    end

    if @purchase.save
      Notifier.purchase_created(@purchase).deliver
      redirect_to(@purchase, notice: I18n.t('notices.purchase.success.created'))
    else
      render action: 'new'
    end
  end

  def update
    @purchase.workflow_state = 'edited'

    if @purchase.update_attributes(params[:purchase])
      redirect_to(@purchase, notice: I18n.t('notices.purchase.success.updated'))
    else
      render action: 'edit'
    end
  end

  def confirmed
    authorize! :manage, Purchase

    @purchases = Purchase.payable_grouped_by_person
  end

  def pay_multiple
    authorize! :manage, Purchase

    purchase_ids = Purchase.pay_multiple!(params)

    redirect_to(confirmed_purchases_path, notice: "Betalda (#{purchase_ids})!")
  end

  def confirm
    @purchase.confirm!
    @purchase.tap do |purchase|
      Notifier.purchase_approved(purchase).deliver if purchase.confirmed?
    end
    redirect_to(purchase_path(@purchase))
  end

  def pay
    @purchase.pay!
    @purchase.tap do |purchase|
      Notifier.purchase_paid(purchase).deliver if purchase.paid?
    end
    redirect_to(purchase_path(@purchase))
  end

  def keep
    authorize! :bookkeep, Purchase
    @purchase.keep!
    @purchase.tap do |purchase|
      if @purchase.bookkept?
        voucher = Mage::Voucher.from_purchase(purchase)
        unless voucher.push(purchase.last_updated_by)
          fail "An error occured when pushing #{purchase.inspect} to MAGE (push returned false)"
        end
      end
    end
    redirect_to(purchase_path(@purchase))
  end

  def cancel
    @purchase.cancel!
    @purchase.tap do |purchase|
      Notifier.purchase_denied(purchase).deliver if purchase.cancelled?
    end
    redirect_to(purchase_path(@purchase))
  end

  protected

  def get_items
    @items = [{ key: :show_purchase_path,
                name: @purchase.slug,
                url: purchase_path(@purchase) }
             ]
    if @purchase.editable?
      @items << {
        key: :edit_purchase_path,
        name: I18n.t('edit'),
        url: edit_purchase_path(@purchase)
      }
    end
  end

  private

  def filter_param(name)
    params[:filter].try(:[], name.to_s)
  end
end
