# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection' do
  subject { page }

  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user, age: 17) }
  let!(:post_a) { create(:post, user: user_a, title: 'abc') }
  let!(:post_b) { create(:post, user: user_b) }
  let!(:post_c) { create(:post, user: user_a, title: 'Cba') }

  it 'render collection table' do
    visit "/users/#{user_a.id}/posts"

    within '.ez-resources-collection-header-container' do
      is_expected.to have_content 'Articles'
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
    # Has only 2 posts as we user custom collection query
    is_expected.to have_css '.ez-resources-collection-table-tr', count: 2
    [post_a, post_c].each do |post|
      within "tr#posts-#{post.id} > td.ez-resources-collection-table-td-actions" do
        is_expected.not_to have_link 'Show', href: "/users/#{user_a.id}"
        is_expected.not_to have_link 'Edit', href: "/users/#{user_a.id}/edit"
      end

      within "tr#posts-#{post.id} > td.ez-t-title" do
        is_expected.to have_content post.title.upcase
      end

      within "tr#posts-#{post.id} > td.ez-t-body" do
        is_expected.to have_content post.body
      end

      within "tr#posts-#{post.id} > td.ez-t-user" do
        is_expected.to have_content post.user.email
      end
    end

    # Sorting
    post_a_tr = find("tr#posts-#{post_a.id}")
    post_c_tr = find("tr#posts-#{post_c.id}")
    expect(post_a_tr).to appear_before(post_c_tr)

    is_expected.to have_link 'Title'
    click_link 'Title'

    expect(post_c_tr).to appear_before(post_a_tr)

    click_link 'Reset'

    # http://www.example.com/users/1/posts?q%5Bs%5D=title+desc

    within '.ez-resources-collection-actions-container' do
      is_expected.to have_link '', href: "/users/#{user_a.id}/posts?view=table"
      is_expected.to have_link '', href: "/users/#{user_a.id}/posts?view=gallery"

      find('#ez-view-gallery').click
    end

    is_expected.to have_current_path "/users/#{user_a.id}/posts?view=gallery"
    is_expected.to have_content 'Hello from gallery view'
  end
end
