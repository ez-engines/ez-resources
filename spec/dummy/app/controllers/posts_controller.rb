class PostsController < ApplicationController
  include Ez::Resources::Manager

  ez_resource do |config|
    config.resources_name = 'Articles'
    config.model = Post
    config.collection_query = ->(model, ctx) { model.where(user_id: ctx.params[:user_id]) }
    config.resource_label = :title
    config.actions = %i[index]
    config.collection_views = [:table, :gallery]

    config.collection_columns do
      column :title,
        presenter: -> (post) { post.title.upcase },
        sortable: true
      column :body
      column :user,
        type: :association,
        getter:  ->(post) { post.user.email },
        searchable:  false
    end
  end
end
