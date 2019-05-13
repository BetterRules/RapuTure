class ScenarioVariableInputOutput < ActiveRecord::Migration[5.2]
  def change
    add_column :scenario_variables, :direction, :string, required: true
  end
end
