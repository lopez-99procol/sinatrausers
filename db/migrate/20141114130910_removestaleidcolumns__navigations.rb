class RemovestaleidcolumnsNavigations < ActiveRecord::Migration
  def change
    remove_column :navigations, :userid
    remove_column :navigations, :users_id
  end
end
