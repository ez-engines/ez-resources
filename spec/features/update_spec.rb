# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update' do
  subject { page }

  let(:user)         { create(:user) }
  let(:random_attrs) { attributes_for(:user) }

  before { visit "/users/#{user.id}/edit" }

  it 'can update record' do
    fill_in 'Email', with: random_attrs[:email]
    fill_in 'Age',   with: random_attrs[:age]
    select random_attrs[:gender].humanize, from: 'Gender'
    uncheck 'Active'

    expect { click_button 'Update' }.not_to change { User.count }

    is_expected.to have_current_path '/users'

    within '.notice' do
      is_expected.to have_content 'User was successfully updated'
    end

    user.reload

    expect(user.email).to  eq random_attrs[:email]
    expect(user.age).to    eq random_attrs[:age]
    expect(user.gender).to eq random_attrs[:gender]
    expect(user.active).to eq false
  end

  it 'can catch errors' do
    fill_in 'Email', with: ''

    expect { click_button 'Update' }.not_to change { User.count }
    is_expected.to have_current_path "/users/#{user.id}"

    within '.alert' do
      is_expected.to have_content 'Invalid User attributes. Please, check the errors below'
    end
  end
end
