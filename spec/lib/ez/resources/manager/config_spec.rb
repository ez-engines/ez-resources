require 'rails_helper'

RSpec.describe Ez::Resources::Manager::Config do
  describe '#to_attrs' do
    context 'index' do
      let(:user_a) { build_stubbed(:user) }
      let(:user_b) { build_stubbed(:user) }

      let(:controller) { instance_double UsersController, controller_name: 'Users', action_name: 'index' }
      let(:config_store) { Ez::Resources::Manager::ConfigStore.new }

      before do
        allow(controller).to receive(:url_for).with(action: :new, only_path: true) { '/users/new' }
        allow(controller).to receive(:url_for).with(action: :index, only_path: true) { '/users' }
        allow(controller).to receive(:url_for).with(action: :create, only_path: true) { '/users' }

        allow(User).to receive(:all) { [user_a, user_b] }
      end

      it 'has default behaviour' do
        instance = described_class.new(controller: controller, store: config_store)

        expect(instance.data.size).to eq 2
        expect(instance.data[0]).to be_instance_of User
        expect(instance.data[0].id).to eq user_a.id
        expect(instance.data[0].email).to eq user_a.email

        expect(instance.data[1]).to be_instance_of User
        expect(instance.data[1].id).to eq user_b.id
        expect(instance.data[1].email).to eq user_b.email

        expect(instance.actions).to eq %i[index show new create edit update destroy]
        expect(instance.model).to eq User
        expect(instance.resource_name).to eq 'User'
        expect(instance.resources_name).to eq 'Users'

        expect(instance.resource_label).to eq :id
        expect(instance.hooks).to eq []

        expect(instance.collection_columns.size).to eq 5
        expect(instance.form_fields).to eq instance.collection_columns
      end
    end
  end
end
