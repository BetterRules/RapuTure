class CreateSimulations < ActiveRecord::Migration[5.2]
  def change
    create_table :simulations do |t|
      t.references :variable, required: true
      t.json :request
      t.json :response
      t.timestamps
    end
  end
end
