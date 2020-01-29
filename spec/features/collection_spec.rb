require 'rails_helper'

RSpec.describe 'Collection' do
  subject { page }

  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user, age: 17) }

  it 'render collection table' do
    visit '/users'

    within '.ez-resources-collection-header-container' do
      is_expected.to have_content 'Users'
    end

    within '.ez-resources-collection-actions-container' do
      is_expected.to have_link 'Add', href: '/users/new'
    end

    # Has table headers
    %w[email age active gender].each do |col_name|
      within "th#ez-t-#{col_name}" do
        is_expected.to have_content(col_name.humanize)
      end
    end

    # Has table content

    # User A
    within "tr#users-#{user_a.id} > td.ez-resources-collection-table-td-actions" do
      is_expected.to have_link 'Show', href: "/users/#{user_a.id}"
      is_expected.to have_link 'Edit', href: "/users/#{user_a.id}/edit"
      is_expected.to have_link 'Clone', href: "/users/#{user_a.id}/clone"
    end

    within "tr#users-#{user_a.id} > td.ez-t-email" do
      is_expected.to have_content user_a.email
    end

    within "tr#users-#{user_a.id} > td.ez-t-active" do
      is_expected.to have_content user_a.active
    end

    within "tr#users-#{user_a.id} > td.ez-t-custom" do
      is_expected.to have_content "custom #{user_a.email}"
    end

    within "tr#users-#{user_a.id} > td.ez-t-avatar" do
      expect(page.find('.t-image-tag')['src']).to have_content "/avatars/#{user_a.id}.jpg"
    end

    within "tr#users-#{user_a.id} > td.ez-t-age" do
      is_expected.to have_content user_a.age
    end

    within "tr#users-#{user_a.id} > td.ez-t-gender" do
      is_expected.to have_content user_a.gender.upcase
    end

    # User B
    within "tr#users-#{user_b.id} > td.ez-resources-collection-table-td-actions" do
      # why?
      # is_expected.not_to have_link 'Show', href: "/users/#{user_b.id}"
      is_expected.to have_link 'Clone', href: "/users/#{user_b.id}/clone"
    end

    within "tr#users-#{user_b.id} > td.ez-t-email" do
      is_expected.to have_content user_b.email
    end

    within "tr#users-#{user_b.id} > td.ez-t-active" do
      is_expected.to have_content user_b.active
    end

    within "tr#users-#{user_b.id} > td.ez-t-custom" do
      is_expected.to have_content "custom #{user_b.email}"
    end

    within "tr#users-#{user_a.id} > td.ez-t-avatar" do
      expect(page.find('.t-image-tag')['src']).to have_content "/avatars/#{user_a.id}.jpg"
    end

    within "tr#users-#{user_b.id} > td.ez-t-age" do
      is_expected.to have_content user_b.age
    end

    within "tr#users-#{user_b.id} > td.ez-t-gender" do
      is_expected.to have_content user_b.gender.upcase
    end
  end
end
