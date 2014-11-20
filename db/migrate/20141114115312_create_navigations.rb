class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      t.string :label
      t.string :link
      t.integer :userid
    end
  end
end
