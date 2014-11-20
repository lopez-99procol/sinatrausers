class ChangeNavigations < ActiveRecord::Migration
  def change
    add_reference :navigations, :users, index: true
  end
end
