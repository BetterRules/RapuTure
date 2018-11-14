# frozen_string_literal: true

class CreateVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :variables do |t|
      t.text :name, null: false, unique: true
      t.text :description
      t.text :href
      t.json :spec
      t.timestamps
    end
  end
end
