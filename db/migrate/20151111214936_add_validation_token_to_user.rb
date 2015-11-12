class AddValidationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :validation_token, :string
  end
end
