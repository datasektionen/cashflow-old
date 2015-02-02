class PurchasesController < ApplicationController
  load_and_authorize_resource except: [:confirmed, :pay_multiple]
  before_filter :get_items, only: [:show, :edit, :update, :destroy]

  def index
    @purchases = Purchase
    search, filter_params = extract_filter_params
    @purchases = @purchases.fuzzy_search(search) unless search.blank?

    filter_params.map do |filter|
      @purchases = @purchases.where(filter)
    end

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
    return "", [] if params[:filter].blank?

    hash = params[:filter].clone
    arel = Purchase.arel_table
    search = hash.delete(:search)

    filter = %w[purchased_on updated_at].reduce([]) do |acc, attr|
      param = hash.delete("#{attr}_from")
      acc << arel[attr].gteq(param) unless param.blank?

      param = hash.delete("#{attr}_to")
      acc << arel[attr].lteq(param) unless param.blank?
      acc
    end

    filter << hash.reject { |_k, v| v.blank? }

    return search, filter
  end
end
