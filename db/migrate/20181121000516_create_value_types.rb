class CreateValueTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :value_types do |t|
      t.text :name
      t.timestamps
    end
    add_reference :variables, :value_type, foreign_key: true
  end
end
