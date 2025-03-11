class RemoveDeviseColumnsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :reset_password_token
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    rename_column :users, :encrypted_password, :password_digest
  end
end
