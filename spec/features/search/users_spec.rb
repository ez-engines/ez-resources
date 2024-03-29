# frozen_string_literal: true

require 'rails_helper'

feature 'Collection users page' do
  subject { page }

  let!(:user_a) { create(:user, email: 'user.a@mail.test', age: '23', name: 'user.a.name') }
  let!(:user_b) { create(:user, email: 'user.b@test.mail', age: '27', name: 'user.b.name') }
  let!(:post_a) { create(:post, title: 'post.atest', user: user_a) }
  let!(:post_b) { create(:post, title: 'post.btest', user: user_b) }

  def search_url(options)
    fields = %w[
      email_cont
      active_eq
      name_cont
      age_cont
      gender_cont
      posts_title_cont
    ]

    query = fields.map { |field| "q[#{field}]=#{options[field.to_sym]}&" }.join

    "/users?#{query}commit=Apply"
  end

  context 'success' do
    before do
      visit '/users'
    end

    scenario 'collection table rendered correctly' do
      is_expected.to have_content 'Users'

      within '.ez-resources-collection-search-container' do
        is_expected.to have_content 'Search & Filter'
        is_expected.to have_field   'Email'
        is_expected.to have_field   'Gender'
        is_expected.to have_field   'Age'
        is_expected.to have_field   'Filter by name'
        is_expected.to have_field   'Post title'

        is_expected.to have_select 'Active', options: ['', 'yes', 'no']
      end
    end

    context 'search' do
      context 'by resource field' do
        context 'when it is a string' do
          scenario 'returns proper result' do
            within '.ez-resources-collection-search-container' do
              fill_in 'Email', with: 'user.a'

              click_button 'Apply'
            end

            is_expected.to have_current_path search_url(email_cont: 'user.a')

            expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

            within '.ez-resources-collection-search-container' do
              is_expected.to have_field 'Email', with: 'user.a'
            end

            within "tr#users-#{user_a.id} > td.ez-t-email" do
              is_expected.to have_content user_a.email
            end
          end
        end

        context 'when it is a link' do
          scenario 'returns proper result' do
            within '.ez-resources-collection-search-container' do
              fill_in 'Filter by name', with: 'user.a'

              click_button 'Apply'
            end

            is_expected.to have_current_path search_url(name_cont: 'user.a')

            expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

            within '.ez-resources-collection-search-container' do
              is_expected.to have_field 'Filter by name', with: 'user.a'
            end

            within "tr#users-#{user_a.id} > td.ez-t-name" do
              is_expected.to have_content user_a.name
            end
          end
        end
      end

      context 'by resource  association field' do
        scenario 'returns proper result' do
          within '.ez-resources-collection-search-container' do
            fill_in 'Post title', with: 'atest'

            click_button 'Apply'
          end

          is_expected.to have_current_path search_url(posts_title_cont: 'atest')

          expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

          within '.ez-resources-collection-search-container' do
            is_expected.to have_field 'Post title', with: 'atest'
          end

          within "tr#users-#{user_a.id} > td.ez-t-title" do
            is_expected.to have_content post_a.title
          end
        end
      end
    end
  end
end
