class ScenarioVariableInputOutput < ActiveRecord::Migration[5.2]
  def change
    add_column :scenario_variables, :direction, :string, required: true
    add_index :scenario_variables, [:scenario_id, :variable_id, :direction], unique: true, name: 'scenario_variables_key'
  end
end
