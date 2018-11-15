class AddNamespaceToVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :namespace, :string
  end
end
