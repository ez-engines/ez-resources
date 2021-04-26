# Ez::Resources
CRUD is boring. As a rails developer, you are familiar with typical tasks as a list of records, create new records, update records and delete it if need it. Next will be pagination, maybe search and filtering. Every new project the same shit. Boring. Boring. Boring.

I want to manage resources within fancy DSL that will do everything for me. Why? Because I can!

## Usage

### Router

Use your rails router as it was used before. No hidden magic here
```ruby
# config/routes.rb

resources :users

```

### Controller

Are you familiar with rails controllers? Of course, you do. Use rails controllers as you already know but with the possibility to automate default workflows such as a collection, create, update or delete

```ruby
class UsersController < ApplicationController
  # Include resource manager module
  include Ez::Resources::Manager

  # Now you have fancy DSL to manage your common workflows
  ez_resource do |config|

    # Set model class or it will try to guess it from controller name
    # config.model = User

    # Collection query or it will try to perfrom .all
    # config.collection_query = -> (search_relation, ctx) { search_relation.where(user_id: ctx.params[:user_id]) }

    # Single resource title presentation
    # config.resource_label = :title

    # Allow list of actions or default index, show, new, create, edit, update and destroy
    # config.actions = %[index new update]

    # Define default collection items
    config.collection_columns do
      column :email
      column :active, type: :boolean
      column :name,   type: :link, presenter: -> (user) { user.name.humanize }
      column :age
      column :avatar, type: :image,       getter:  ->(user) { "/avatars/#{user.id}.jpg" }, class: "t-image-tag"
      column :custom, type: :custom,      builder: ->(user) { "custom #{user.email}" }
      column :gender, type: :association, getter:  ->(user) { user.gender.upcase }
      column :title,  type: :association, getter:  ->(user) { user.posts.pluck(:title) }, association: :posts, title: 'Post title'
    end

    # Add custom collection templates
    # config.collection_views = [:table, :gallery]

    # Form fields
    config.form_fields do
      field :email
      field :name
      field :active, type: :boolean, default: -> { true }
      field :age,    type: :integer, default: -> { 18 }, required: false
      field :gender, type: :select,  default: -> { 'Other' }, collection: %w(Male Female Other)
    end

    # Custom collection actions
    config.collection_actions do
      action :clone, proc { |_ctx, user| "/users/#{user.id}/clone" }, method: :post, class: 'custom-action-class'
    end

    # Hooks for authentication or any what you need
    config.hooks do
      add :can_update?, proc { |ctx, user| user.age >= 18 }
    end
  end
end
```

### Enjoy
That's all. More documentation coming soon ;)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ez-resources'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ez-resources
```

## TODO
- [ ] Add generators for configuration and I18n

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
