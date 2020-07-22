# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pagination' do
  subject { page }

  let!(:all_users) do
    21.times.map { create(:user) }
  end

  it 'render collection table' do
    visit '/users'

    is_expected.to have_selector('tr.ez-resources-collection-table-tr', count: 20)

    within 'nav.pagination' do
      is_expected.to have_content 'Prev'
      is_expected.to have_content '1'
      is_expected.to have_link    '2',    href: '/users?page=2'
      is_expected.to have_link    'Next', href: '/users?page=2'
    end
  end
end
