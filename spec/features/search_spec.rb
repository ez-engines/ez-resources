require 'rails_helper'

RSpec.describe 'Collection' do
  subject { page }

  let!(:user_a) { create(:user, email: 'user.a@mail.test', age: '23') }
  let!(:user_b) { create(:user, email: 'user.b@test.mail', age: '27') }

  it 'render collection table' do
    visit '/users'

    is_expected.to have_content 'Users'

    within ".ez-resources-collection-search-container" do
      is_expected.to have_content 'Search & Filter'
      is_expected.to have_field 'Email'
      is_expected.to have_field 'Age'

      # TODO: Support other types: boolean, text, association, etc
      # is_expected.to have_unchecked_field 'Active'
      # is_expected.to have_field 'Gender'
      # is_expected.to have_field 'Notes'
    end

    #=== Can search by email contains =========================================
    within ".ez-resources-collection-search-container" do
      fill_in 'Email', with: 'user.a'

      click_button 'Apply'
    end

    is_expected.to have_current_path '/users?q[email_cont]=user.a&q[age_cont]=&commit=Apply'

    expect(page).to have_selector('.ez-resources-collection-table-tr', count: 1)

    within ".ez-resources-collection-search-container" do
      is_expected.to have_field 'Email', with: 'user.a'
    end

    within "tr#users-#{user_a.id} > td.ez-t-email" do
      is_expected.to have_content user_a.email
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
end
