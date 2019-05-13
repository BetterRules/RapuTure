class AddColumnToParameters < ActiveRecord::Migration[5.2]
  def change
    add_column :parameters, :filename, :string
  end
end
