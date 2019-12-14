class UsersController < ApplicationController
  include Ez::Resources::Manager

  ez_resource do |config|
    config.form_fields do
      field :email
      field :active, type: :boolean, default: -> { true }
      field :age,    type: :integer, default: -> { 18 }, required: false
      field :gender, type: :select,  default: -> { 'Other' }, collection: %w(Male Female Other)
    end

    config.hooks do
      add :can_edit?, ->(user) { user.age >= 18 }
    end
  end
end
