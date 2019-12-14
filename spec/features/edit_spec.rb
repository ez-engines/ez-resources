require 'rails_helper'

RSpec.describe 'Edit' do
  subject { page }

  let!(:user) { create(:user) }
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
end
