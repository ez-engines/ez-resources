class UsersController < ApplicationController
  include Ez::Resources::Manager

  ez_resource do |config|
    config.form_fields do
      field :email
      field :active, type: :boolean, default: -> { true }
      field :age,    type: :integer, default: -> { 18 }, required: false
      field :gender, type: :select,  default: -> { 'Other' }, collection: %w(Male Female Other)
    end
  end
end
