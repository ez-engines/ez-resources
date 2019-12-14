require 'rails_helper'

RSpec.describe 'New' do
  subject { page }

  it 'render new table' do
    visit '/users'

    click_link 'Add'

    is_expected.to have_current_path '/users/new'
    is_expected.to have_content 'New user'
    is_expected.to have_field 'Email', text: ''
    is_expected.to have_field 'Age' #, text: 18
    is_expected.to have_unchecked_field 'Active'
    is_expected.to have_select 'Gender', options: ['', 'Male', 'Female', 'Other'], selected: 'Other'
  end
end
