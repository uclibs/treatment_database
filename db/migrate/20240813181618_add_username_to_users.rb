class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: true

    User.reset_column_information

    # Populate the username column with a value for existing users
    User.find_each do |user|
      if user.username.blank?
        user.update_columns(username: user.email.split('@').first)
      end
    end

    # Now that all users have a username, enforce the NOT NULL constraint
    change_column_null :users, :username, false

    # Add a unique index on the username column
    add_index :users, :username, unique: true
  end
end
