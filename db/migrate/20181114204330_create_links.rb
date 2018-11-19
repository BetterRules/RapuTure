# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.integer :link_to
      t.integer :link_from
      t.timestamps
    end
  end
end
