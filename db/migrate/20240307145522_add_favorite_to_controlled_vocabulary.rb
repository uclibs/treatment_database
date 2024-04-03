class AddFavoriteToControlledVocabulary < ActiveRecord::Migration[6.1]
  def change
    add_column :controlled_vocabularies, :favorite, :boolean, default: false
  end
end
