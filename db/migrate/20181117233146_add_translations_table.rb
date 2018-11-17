class AddTranslationsTable < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Variable.create_translation_table! description: :string
      end

      dir.down do
        Variable.drop_translation_table!
      end
    end
  end
end
