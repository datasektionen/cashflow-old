class PeopleController < ApplicationController
  load_and_authorize_resource :person
  before_filter :get_items

  def index
    @people = Person.accessible_by(current_ability)
    authorize! :access, @people
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    search_options = params[:person].slice(*%w(login ugid email))
    @person = Person.where(search_options).first unless search_options.blank?
    @person ||= Person.from_ldap(search_options)

    if @person.save
      redirect_to(@person, notice: I18n.t('notices.person.success.created'))
    else
      render action: 'new'
    end
  end

  def update
    if params[:person].try(:[], :role) && current_user.is?(:admin)
      @person.role = params[:person][:role]
      @person.save
    end
    if @person.update_attributes(params[:person])
      redirect_to(@person, notice: I18n.t('notices.person.success.created'))
    else
      render action: 'edit'
    end
  end

  def search
    search_options = params.slice(*%w(login ugid email))
    Rails.logger.info(search_options)

    respond_to do |format|
      format.json do
        if Person.where(search_options).any? && person = Person.where(search_options).first
          render json: { person: { name: person.name }, error: I18n.t('activerecord.errors.models.person.exists'), url: person_url(person) }
        else
          person = Person.from_ldap(search_options)
          Rails.logger.info(person)
          render json: person.to_json
        end
      end
    end
  end

  protected

  def get_items
    if @person && @person.persisted?
      @items = [
        { key: :show_person, name: @person.name, url: person_path(@person) },
        { key: :edit_person, name: I18n.t('edit'), url: edit_person_path(@person) }
      ]
    else
      @items = [
        { key: :all_people, name: I18n.t('navigation.all_people'), url: people_path },
        { key: :new_person, name: I18n.t('navigation.new_person'), url: new_person_path }
      ]
    end
  end
end
