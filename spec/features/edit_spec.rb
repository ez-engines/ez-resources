# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit' do
  subject { page }

  let!(:user)             { create(:user) }
  let(:random_attributes) { attributes_for(:user) }

  it 'render edit form' do
    visit '/users'

    click_link 'Edit'

    is_expected.to have_current_path "/users/#{user.id}/edit"

    is_expected.to have_content "Edit #{user.id} user"

    is_expected.to have_field 'Email', with: user.email
    is_expected.to have_field 'Age',   with: user.age
    is_expected.to have_checked_field 'Active'

    is_expected.to have_select 'Gender', options: ['', 'Male', 'Female', 'Other'], selected: user.gender

    click_link 'Cancel'
    is_expected.to have_current_path '/users'
  end

  let(:young_user) { create(:user, age: 13) }

  it 'prevents edit by :can_edit? hooks' do
    visit "/users/#{young_user.id}/edit"

    is_expected.to have_current_path '/'

    within '.alert' do
      is_expected.to have_content 'Sorry, but this action is unavailable'
    end
  end
end
