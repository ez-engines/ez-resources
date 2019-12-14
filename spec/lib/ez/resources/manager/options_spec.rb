require 'rails_helper'

RSpec.describe Ez::Resources::Manager::Options do
  describe '#to_attrs' do
    context 'default case' do
      let(:user_a) { build_stubbed(:user) }
      let(:user_b) { build_stubbed(:user) }

      let(:controller) { instance_double UsersController, controller_name: 'Users', action_name: 'index' }
      let(:config) { Ez::Resources::Manager::Config.new }

      before do
        allow(controller).to receive(:url_for).with(action: :new, only_path: true) { '/users/new' }
        allow(controller).to receive(:url_for).with(action: :index, only_path: true) { '/users' }

        allow(User).to receive(:all) { [user_a, user_b] }
      end

      it 'generates defaul attributes' do
        data, options = described_class.new(controller: controller, config: config).to_attrs

        expect(data.size).to eq 2
        expect(data[0]).to be_instance_of User
        expect(data[0].id).to eq user_a.id
        expect(data[0].email).to eq user_a.email

        expect(data[1]).to be_instance_of User
        expect(data[1].id).to eq user_b.id
        expect(data[1].email).to eq user_b.email

        expect(options[:resource_name]).to eq 'Users'
        expect(options[:new_resource_path]).to eq '/users/new'
        expect(options[:collection_path]).to eq '/users'

        expect(options[:collection_columns].size).to eq 5
        expect(options[:form_fields]).to eq options[:collection_columns]
      end
    end

    context 'custom options' do
      # DummyRecord = Struct.new(:id, :name, keyword_init: true)
      # DummyColumn = Struct.new(:name, :sql_type_metadata, keyword_init: true)
      # DummySQLMetaData = Struct.new(:type, keyword_init: true)

      # class DummyModel
      #   def self.all
      #     [
      #       DummyRecord.new(id: 1, name: 'First'),
      #       DummyRecord.new(id: 2, name: 'Second')
      #     ]
      #   end

      #   def self.columns
      #     [
      #       DummyColumn.new(name: :id, sql_type_metadata: DummySQLMetaData.new(type: :integer)),
      #       DummyColumn.new(name: :name, sql_type_metadata: DummySQLMetaData.new(type: :string))
      #     ]
      #   end
      # end
    end
  end
end
