class CreateScenarios < ActiveRecord::Migration[5.2]
  def change
    create_table :scenarios do |t|
      t.string :name, null: false, unique: true
      t.json :inputs
      t.json :outputs
      t.string :period
      t.integer :error_margin
      t.string :namespace
      t.timestamps
    end
  end
end
