# frozen_string_literal: true

require 'rails_helper'

feature 'Collection posts page' do
  subject { page }

  let!(:user_a) { create(:user, email: 'user.a@mail.test', age: '23', name: 'user.a.name') }
  let!(:user_b) { create(:user, email: 'user.b@test.mail', age: '27', name: 'user.b.name') }
  let!(:post_a) { create(:post, title: 'post.atest', user: user_a) }
  let!(:post_b) { create(:post, title: 'post.btest', user: user_b) }

  context 'success' do
    before do
      visit "/users/#{user_a.id}/posts"
    end

    scenario 'search by user_name' do
      within '.ez-resources-collection-search-container' do
        check "checkbox-#{user_a.id}"

        click_button 'Apply'
      end
      expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

      within "tr#posts-#{post_a.id} > td.ez-t-title" do
        is_expected.to have_content post_a.title.upcase
      end
    end
  end
end
