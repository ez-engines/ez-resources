# frozen_string_literal: true

require 'rails_helper'

feature 'Collection page' do
  subject { page }

  let!(:user_a) { create(:user, email: 'user.a@mail.test', age: '23', name: 'user.a.name') }
  let!(:user_b) { create(:user, email: 'user.b@test.mail', age: '27', name: 'user.b.name') }
  let!(:post_a) { create(:post, title: 'post.atest', user: user_a) }
  let!(:post_b) { create(:post, title: 'post.btest', user: user_b) }

  def search_url(options)
    fields = %w[
      email_cont
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
        is_expected.to have_field   'Name'
        is_expected.to have_field   'Post title'

        # TODO: Support other types: boolean, text, association, etc
        # is_expected.to have_unchecked_field 'Active'
        # is_expected.to have_field 'Notes'
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
              fill_in 'Name', with: 'user.a'

              click_button 'Apply'
            end

            is_expected.to have_current_path search_url(name_cont: 'user.a')

            expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

            within '.ez-resources-collection-search-container' do
              is_expected.to have_field 'Name', with: 'user.a'
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

  # TODO: Disvover why it not works with integer values
  #=== Can search by age contains ===========================================
  # within ".ez-resources-collection-search-container" do
  #   fill_in 'Age', with: '23'

  #   click_button 'Apply'
  # end

  # is_expected.to have_current_path '/users?q[email_cont]=user.a&q[age_cont]=23&commit=Apply'

  # within ".ez-resources-collection-search-container" do
  #   is_expected.to have_field 'Age', with: '23'
  # end

  # is_expected.to have_content 'Users (1)'

  # within "tr#users-#{user_a.id} > td.ez-t-email" do
  #   is_expected.to have_content user_a.email
  # end
end
