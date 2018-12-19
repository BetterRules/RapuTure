# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.text :name
      t.text :description
      t.text :documentation
      t.text :plural
      t.timestamps
    end
    create_table :roles do |t|
      t.references :entity
      t.text :name
      t.text :plural
      t.text :description
      t.integer :max
      t.timestamps
    end

    add_reference :variables, :entity, foreign_key: true
  end
end
