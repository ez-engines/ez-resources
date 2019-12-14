require 'rails_helper'

RSpec.describe Ez::Resources::Manager::ConfigStore do
  class DummyController
    extend Ez::Resources::Manager::DSL

    ez_resource do |config|
      config.actions %i[index new create edit update]
      config.model 'Model'
      config.resource_name 'Resource Name'
      config.resource_label :email
      config.resources_name 'Resources'

      # config.collection_columns %i[one two]

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
    it 'DSL' do
      expect(cfg.actions.size).to eq 5

      expect(cfg.model).to eq 'Model'
      expect(cfg.resource_name).to eq 'Resource Name'
      expect(cfg.resource_label).to eq :email
      expect(cfg.resources_name).to eq 'Resources'

      expect(cfg.hooks.size).to eq 1
      expect(cfg.hooks[0].name).to eq :can_edit
      expect(cfg.hooks[0].callback).to be_present
      expect(cfg.hooks[0].callback.call({age: 21})).to eq true
      expect(cfg.hooks[0].callback.call({age: 16})).to eq false

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
