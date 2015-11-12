class AddValidatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_validated_at, :datetime
  end
end
