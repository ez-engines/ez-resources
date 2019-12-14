require 'rails_helper'

RSpec.describe 'New' do
  subject { page }

  it 'render new table' do
    visit '/users'

    click_link 'Add'

    is_expected.to have_current_path '/users/new'
  end
end
