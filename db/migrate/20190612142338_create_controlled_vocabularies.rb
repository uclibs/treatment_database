class CreateControlledVocabularies < ActiveRecord::Migration[5.2]
  def change
    create_table :controlled_vocabularies do |t|
      t.string :vocabulary
      t.string :key
      t.boolean :active

      t.timestamps
    end
  end
end
