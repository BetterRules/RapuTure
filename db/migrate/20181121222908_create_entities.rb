class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.text :name
      t.text :description
      t.text :plural
      t.json :spec
      t.timestamps
    end
  end
end
