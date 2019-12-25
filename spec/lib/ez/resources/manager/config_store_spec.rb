require 'rails_helper'

RSpec.describe Ez::Resources::Manager::ConfigStore do
  class DummyController
    extend Ez::Resources::Manager::DSL

    ez_resource do |config|
      config.actions = %i[index new create edit update]
      config.model = 'Model'
      config.collection_query = ->(model) { "#{model} query" }
      config.paginate_collection = false
      config.collection_search = false
      config.resource_name = 'Resource Name'
      config.resource_label = :email
      config.resources_name = 'Resources'

      config.collection_columns do
        column :id,     type: :integer
        column :name,   type: :string
        column :active, type: :boolean
        column :assoc,  type: :association, getter: ->(record) { record.upcase }
      end

      config.hooks do
        add :can_edit, ->(user) { user[:age] > 18 }
      end

      config.form_fields do
        field :id,     type: :integer
        field :name,   type: :string
        field :gender, type: :select, collection: %w[Male Female], default: -> { 'Male' }
        field :age,    type: :integer, default: -> { 18 }
      end
    end
  end

  let(:controller) { DummyController.new }

  let(:cfg) { DummyController.ez_resource_config_store }

  describe '.ez_resource' do
    it 'has actions' do
      expect(cfg.actions.size).to eq 5
    end

    it 'build model' do
      expect(cfg.model).to eq 'Model'
    end

    it 'has collection_query' do
      expect(cfg.collection_query.call(cfg.model)).to eq 'Model query'
    end

    it 'has paginate_collection' do
      expect(cfg.paginate_collection).to eq false
    end

    it 'has collection_search' do
      expect(cfg.collection_search).to eq false
    end

    it 'build resource_name' do
      expect(cfg.resource_name).to eq 'Resource Name'
    end

    it 'build resource_label' do
      expect(cfg.resource_label).to eq :email
    end

    it 'build resources_name' do
      expect(cfg.resources_name).to eq 'Resources'
    end

    it 'has hooks' do
      expect(cfg.hooks.size).to eq 1
      expect(cfg.hooks[0].name).to eq :can_edit
      expect(cfg.hooks[0].callback).to be_present
      expect(cfg.hooks[0].callback.call({age: 21})).to eq true
      expect(cfg.hooks[0].callback.call({age: 16})).to eq false
    end

    it 'has collection_columns' do
      expect(cfg.collection_columns.size).to eq 4
      expect(cfg.collection_columns[0]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.collection_columns[0].name).to eq :id
      expect(cfg.collection_columns[0].title).to eq 'Id'
      expect(cfg.collection_columns[0].type).to eq :integer

      expect(cfg.collection_columns[1]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.collection_columns[1].name).to eq :name
      expect(cfg.collection_columns[1].title).to eq 'Name'
      expect(cfg.collection_columns[1].type).to eq :string

      expect(cfg.collection_columns[2]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.collection_columns[2].name).to eq :active
      expect(cfg.collection_columns[2].title).to eq 'Active'
      expect(cfg.collection_columns[2].type).to eq :boolean

      expect(cfg.collection_columns[3]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.collection_columns[3].name).to eq :assoc
      expect(cfg.collection_columns[3].title).to eq 'Assoc'
      expect(cfg.collection_columns[3].type).to eq :association
      expect(cfg.collection_columns[3].getter.call('hello')).to eq 'HELLO'
    end

    it 'has form_fields' do
      expect(cfg.form_fields.size).to eq 4
      expect(cfg.form_fields[0]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.form_fields[0].name).to eq :id
      expect(cfg.form_fields[0].title).to eq 'Id'
      expect(cfg.form_fields[0].type).to eq  :integer
      expect(cfg.form_fields[0].default).to eq nil
      expect(cfg.form_fields[0].collection).to eq []

      expect(cfg.form_fields[1]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.form_fields[1].name).to eq :name
      expect(cfg.form_fields[1].title).to eq 'Name'
      expect(cfg.form_fields[1].type).to eq  :string
      expect(cfg.form_fields[1].default).to eq nil
      expect(cfg.form_fields[1].collection).to eq []

      expect(cfg.form_fields[2]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.form_fields[2].name).to eq :gender
      expect(cfg.form_fields[2].title).to eq 'Gender'
      expect(cfg.form_fields[2].type).to eq  :select
      expect(cfg.form_fields[2].default.call).to eq 'Male'
      expect(cfg.form_fields[2].collection).to eq ['Male', 'Female']

      expect(cfg.form_fields[3]).to be_instance_of(Ez::Resources::Manager::Field)
      expect(cfg.form_fields[3].name).to eq :age
      expect(cfg.form_fields[3].title).to eq 'Age'
      expect(cfg.form_fields[3].type).to eq  :integer
      expect(cfg.form_fields[3].default.call).to eq 18
      expect(cfg.form_fields[3].collection).to eq []
    end
  end

  describe '.ez_resource_config_store' do
    it 'ez_resource_config_store' do
      expect(DummyController.ez_resource_config_store).to be_instance_of(Ez::Resources::Manager::ConfigStore)
    end
  end
end
