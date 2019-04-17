class CreateJoinTableScenarioVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :scenario_variables do |t|
      t.references :scenario, foreign_key: true
      t.references :variable, foreign_key: true 
    end
  end
end
