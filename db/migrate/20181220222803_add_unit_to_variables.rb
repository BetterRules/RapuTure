class AddUnitToVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :unit, :string
  end
end
