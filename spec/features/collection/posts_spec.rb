# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection' do
  subject { page }

  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user, age: 17) }
  let!(:post_a) { create(:post, user: user_a) }
  let!(:post_b) { create(:post, user: user_b) }

  it 'render collection table' do
    visit "/users/#{user_a.id}/posts"

    within '.ez-resources-collection-header-container' do
      is_expected.to have_content 'Posts'
    end

    within '.ez-resources-collection-actions-container' do
      is_expected.not_to have_link 'Add'
    end

    # Has table headers
    %w[title body user].each do |col_name|
      within "th#ez-t-#{col_name}" do
        is_expected.to have_content(col_name.humanize)
      end
    end

    # Has table content
    # Has onlu 1 post as we user custom collection query
    is_expected.to have_css '.ez-resources-collection-table-tr', count: 1

    within "tr#posts-#{post_a.id} > td.ez-resources-collection-table-td-actions" do
      is_expected.not_to have_link 'Show', href: "/users/#{user_a.id}"
      is_expected.not_to have_link 'Edit', href: "/users/#{user_a.id}/edit"
    end

    within "tr#posts-#{post_a.id} > td.ez-t-title" do
      is_expected.to have_content post_a.title
    end

    within "tr#posts-#{post_a.id} > td.ez-t-body" do
      is_expected.to have_content post_a.body
    end

    within "tr#posts-#{post_a.id} > td.ez-t-user" do
      is_expected.to have_content post_a.user.email
    end
  end
end
