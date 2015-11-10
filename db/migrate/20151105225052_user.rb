class User < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.timestamps
      t.string      :email,         null: false, unique: true
      t.string      :password_hash, null: false
    end
  end
end
