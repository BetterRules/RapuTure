class CreateJoinTableScenarioVariables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :scenarios, :variables do |t|
      t.index [:scenario_id, :variable_id]
      t.index [:variable_id, :scenario_id]
    end
  end
end
