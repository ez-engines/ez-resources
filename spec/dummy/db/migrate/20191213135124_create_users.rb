class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :age
      t.boolean :active
      t.string :gender
      t.text :notes

      t.timestamps
    end
  end
end
