class UsersController < ApplicationController
  include Ez::Resources::Manager

  ez_resource do |config|
    config.form_fields do
      field :email
      field :active, type: :boolean, default: -> { true }
      field :age,    type: :integer, default: -> { 18 }, required: false
      field :gender, type: :select,  default: -> { 'Other' }, collection: %w(Male Female Other)
    end

    config.collection_columns do
      column :email
      column :active,  type: :boolean
      column :age
      column :avatar, type: :image, getter: -> (user) { "/avatars/#{user.id}.jpg" }, class: "t-image-tag"
      column :custom,  type: :custom, builder: ->(user) { "custom #{user.email}" }
      column :gender,  type: :association, getter: ->(user) { user.gender.upcase }
    end

    config.hooks do
      add :can_update?, proc { |ctx, user| user.age >= 18 }
    end
  end
end
