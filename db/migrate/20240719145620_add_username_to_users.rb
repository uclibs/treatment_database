class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :username, :string
    # Ensuring the column is unique
    add_index :users, :username, unique: true

    # Set default username for existing users based on their email
    User.reset_column_information
    User.find_each do |user|
      default_username = user.email.split('@').first
      user.update(username: default_username)
    end

    change_column_null :users, :username, false
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
  end
end
