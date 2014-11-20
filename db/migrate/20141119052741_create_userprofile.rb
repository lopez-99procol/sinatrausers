class CreateUserprofile < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users do |t|
      t.string   :name
      t.string   :firstname
      t.string   :email
      t.string   :bio
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :encrypted_password
      t.string   :salt
    end
    
    drop_table :navigations
    create_table :navigations do |t|
      t.string  :label
      t.string  :link
      t.boolean :free
    end
    
    create_table :userprofiles do |t|
      t.belongs_to  :user
      t.belongs_to  :navigation
      t.datetime    :renewaldate
    end
  end
end
