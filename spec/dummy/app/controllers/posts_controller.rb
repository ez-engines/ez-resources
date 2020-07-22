class PostsController < ApplicationController
  include Ez::Resources::Manager

  ez_resource do |config|
    config.model = Post
    config.collection_query = ->(model, ctx) { model.where(user_id: ctx.params[:user_id]) }
    config.resource_label = :title
    config.actions = %i[index]
    config.collection_columns do
      column :title
      column :body
      column :user,
        type: :association,
        getter:  ->(post) { post.user.email },
        searchable:  false
    end
  end
end
