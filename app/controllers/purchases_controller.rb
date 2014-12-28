class PurchasesController < ApplicationController
  load_and_authorize_resource except: [:confirmed, :pay_multiple]
  before_filter :get_items, only: [:show, :edit, :update, :destroy]

  expose(:budget_posts) { BudgetPost.includes(:business_unit).all }

  def index
    # filter, search = extract_filter_params
    @purchases = Purchase
    extract_filter_params.map do |filter|
      @purchases = @purchases.where(filter)
    end
    # @purchases = @purchases.search(search) unless search.blank?
    # @purchases = @purchases.where(*filter) unless filter.blank?

    @purchases = @purchases.page(params[:page])
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
    if @purchase.confirm!
      Notifier.purchase_approved(@purchase).deliver
    end
    redirect_to(purchase_path(@purchase))
  end

  def pay
    if @purchase.pay!
      Notifier.purchase_paid(@purchase).deliver
    end
    redirect_to(purchase_path(@purchase))
  end

  def keep
    authorize! :bookkeep, Purchase
    if @purchase.keep!
      voucher = Mage::Voucher.from_purchase(@purchase)
      unless voucher.push(@purchase.last_updated_by)
        fail "An error occured when pushing #{@purchase.inspect} to MAGE (push returned false)"
      end
    end
    redirect_to(purchase_path(@purchase))
  end

  def cancel
    if @purchase.cancel!
      Notifier.purchase_denied(@purchase).deliver
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

  def extract_filter_params
    return [] if params[:filter].blank?

    arel = Purchase.arel_table
    filter = params[:filter].reject {|k,v| v.blank? }

    %w[purchased_on updated_at].reduce(filter) do |acc, attr|
      param = params[:filter].delete("#{attr}_from")
      acc << arel[attr].gt(param) unless param.blank?

      param = params[:filter].delete("#{attr}_to")
      acc << arel[attr].lt(param) unless param.blank?
      acc
    end
  end
end
