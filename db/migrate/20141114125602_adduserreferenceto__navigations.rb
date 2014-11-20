class AdduserreferencetoNavigations < ActiveRecord::Migration
  def change
    change_table :navigations do |t|
      t.references :user, index: true 
    end
  end
  def down
    change_table :navigations do |t|
      t.remove :users_id
    end
  end
end
