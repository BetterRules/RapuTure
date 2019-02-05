class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|
      t.text :name, null: false, unique: true
      t.text :description
      t.text :href
      t.text :source
      t.json :brackets
      t.json :metadata
      t.json :values
    end
  end
end
