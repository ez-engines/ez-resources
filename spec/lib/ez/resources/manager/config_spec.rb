require 'rails_helper'

RSpec.describe Ez::Resources::Manager::Config do
  let(:controller) { instance_double UsersController, controller_name: 'Users', action_name: action_name, params: {} }
  let(:dsl_store)  { Ez::Resources::Manager::ConfigStore.new }

  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user) }

  before do
    allow(controller).to receive(:url_for).with(action: :new, only_path: true) { '/users/new' }
    allow(controller).to receive(:url_for).with(action: :index, only_path: true) { '/users' }
    allow(controller).to receive(:url_for).with(action: :create, only_path: true) { '/users' }
  end

  context 'default behaviour' do
    context 'index' do
      let(:action_name) { 'index' }

      let(:cfg) { described_class.new(controller: controller, dsl_config: dsl_store) }

      describe '#data' do
        it 'has .all behaviour' do
          expect(cfg.data.size).to eq 2
          expect(cfg.data[0]).to be_instance_of User
          expect(cfg.data[0].id).to eq user_a.id
          expect(cfg.data[0].email).to eq user_a.email

          expect(cfg.data[1]).to be_instance_of User
          expect(cfg.data[1].id).to eq user_b.id
          expect(cfg.data[1].email).to eq user_b.email
        end
      end

      describe '#actions' do
        it 'has default 7 actiions' do
          expect(cfg.actions).to eq %i[index show new create edit update destroy]
        end
      end

      describe '#model' do
        it 'guess model from controller name' do
          expect(cfg.model).to eq User
        end
      end

      describe '#resource_name' do
        it 'get from model name and singularize' do
          expect(cfg.resource_name).to eq 'User'
        end
      end

      describe '#resources_name' do
        it 'get from resource_name and pluralize' do
          expect(cfg.resources_name).to eq 'Users'
        end
      end

      describe '#resource_label' do
        it 'id by default' do
          expect(cfg.resource_label).to eq :id
        end
      end

      describe '#hooks' do
        it 'empty by default' do
          expect(cfg.hooks).to eq []
        end
      end

      describe '#collection_columns' do
        it 'extracted from model.columns by default' do
          expect(cfg.collection_columns.size).to eq 5
        end
      end

      describe '#form_fields' do
        it 'eq collection_columns by default' do
          expect(cfg.form_fields).to eq cfg.collection_columns
        end
      end
    end
  end

  context 'with dsl configuration' do
    before do
      dsl_store.collection_query = ->(model) { model.preload(:posts) }
      dsl_store.paginate_collection = false
    end

    context 'index' do
      let(:action_name) { 'index' }

      let(:cfg) { described_class.new(controller: controller, dsl_config: dsl_store) }

      describe '#data' do
        it 'call custom labmda with model as first argument' do
          expect(cfg.data).to eq([user_a, user_b])
          expect(cfg.paginator).to eq nil
        end
      end
    end
  end
end
