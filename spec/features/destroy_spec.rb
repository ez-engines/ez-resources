# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit' do
  subject { page }

  let!(:user)             { create(:user) }
  let(:random_attributes) { attributes_for(:user) }

  it 'render edit form' do
    visit '/users'
    save_and_open_page
    expect(User.count).to eq 1

    click_link 'Remove'

    expect(User.count).to eq 0

    within '.notice' do
      is_expected.to have_content 'User was successfully removed'
    end

    is_expected.to have_current_path '/users'
  end
end
