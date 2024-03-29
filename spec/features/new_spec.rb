# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New' do
  subject { page }

  it 'render new form' do
    visit '/users'

    click_link 'Add'

    is_expected.to have_current_path '/users/new'
    is_expected.to have_content 'New user'
    is_expected.to have_field 'Email', text: ''
    is_expected.to have_field 'Age', with: 18
    is_expected.to have_checked_field 'Active'
    is_expected.to have_select 'Gender', options: ['', 'Male', 'Female', 'Other'], selected: 'Other'

    click_link 'Cancel'
    is_expected.to have_current_path '/users'
  end
end
