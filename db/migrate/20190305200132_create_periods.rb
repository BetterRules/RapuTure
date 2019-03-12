class CreatePeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :periods do |t|
      t.text :name, unique: true, required: true
      t.timestamps
    end
    add_reference :variables, :period, foreign_key: true
  end
end
