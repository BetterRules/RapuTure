class RemoveNameFromParameters < ActiveRecord::Migration[5.2]
  def change
    remove_column :parameters, :name, :text
    remove_column :parameters, :source, :text
    remove_column :parameters, :metadata, :json
  end
end
