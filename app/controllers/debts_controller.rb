class DebtsController < ApplicationController
  load_and_authorize_resource

  def index
    @debts = Debt.accessible_by(current_ability)
  end

  def show
  end

  def new
    @debt = Debt.new
  end

  def create
    @debt = Debt.new(params[:debt])

    if @debt.save
      redirect_to(@debt, notice: I18n.t('notices.debt.success.created'))
    else
      render action: 'new'
    end
  end

  def cancel
    @debt.cancel!
    redirect_to(debt_path(@debt))
  end

  def pay
    @debt.pay!
    redirect_to(debt_path(@debt))
  end

  def keep
    @debt.keep!
    redirect_to(debt_path(@debt))
  end
end
