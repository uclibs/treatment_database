class RemoveEmailAndPasswordDigestFromUsers < ActiveRecord::Migration[6.1]
  def up
    # Ensure all users have a username before proceeding
    User.reset_column_information
    if User.where(username: [nil, '']).exists?
      raise "Cannot proceed: Some users are missing a username."
    end

    # Remove the unique index on the email column
    remove_index :users, :email if index_exists?(:users, :email)

    # Remove the email and password_digest columns
    remove_column :users, :email
    remove_column :users, :password_digest
  end

  def down
    # Add the email column back
    add_column :users, :email, :string, null: false, default: ''

    # Re-create the unique index on the email column
    add_index :users, :email, unique: true

    # Add the password_digest column back
    add_column :users, :password_digest, :string, null: false, default: ''

    # Reconstructing email from username
    User.reset_column_information
    User.find_each do |user|
      user.update_columns(email: "#{user.username}@uc.edu", password_digest: '')
    end
  end
end
