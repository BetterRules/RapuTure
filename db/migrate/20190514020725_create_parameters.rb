class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|
      t.text :filename, null: false, unique: true
      t.text :description
      t.text :href
      t.json :brackets
      t.json :values
    end
  end
end
