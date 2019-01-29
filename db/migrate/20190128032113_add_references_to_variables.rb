class AddReferencesToVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :references, :string, array: true, default: []
  end
end
