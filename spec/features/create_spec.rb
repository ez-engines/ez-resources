# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  subject { page }

  let(:random_attrs) { attributes_for(:user) }
  let(:created_record) { User.last }

  it 'can create record' do
    visit '/users/new'

    fill_in 'Email', with: random_attrs[:email]
    fill_in 'Name',  with: random_attrs[:name]
    fill_in 'Age',   with: random_attrs[:age]
    select random_attrs[:gender].humanize, from: 'Gender'

    expect { click_button 'Create' }.to change { User.count }.from(0).to(1)
    is_expected.to have_current_path '/users'

    within '.notice' do
      is_expected.to have_content 'User was successfully created'
    end

    expect(created_record.email).to  eq random_attrs[:email]
    expect(created_record.age).to    eq random_attrs[:age]
    expect(created_record.gender).to eq random_attrs[:gender]
    expect(created_record.name).to   eq random_attrs[:name]
  end

  it 'can catch errors' do
    visit '/users/new'

    fill_in 'Email', with: ''

    expect { click_button 'Create' }.not_to change { User.count }
    is_expected.to have_current_path '/users'

    within '.alert' do
      is_expected.to have_content 'Invalid User attributes. Please, check the errors below'
    end
  end
end
