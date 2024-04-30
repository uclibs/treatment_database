class UpdateUsersTableConstraints < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :display_name, false
    change_column :users, :role, :string, null: false, default: 'read_only'
    change_column :users, :account_active, :boolean, null: false, default: true
    change_column_default :users, :email, nil
    change_column_null :users, :email, false
    change_column_default :users, :password_digest, nil
    change_column_null :users, :password_digest, false
  end
end
