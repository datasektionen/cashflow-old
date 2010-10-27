class BusinessUnit < ActiveRecord::Base
  validates_presence_of :name, :short_name, :description
end
