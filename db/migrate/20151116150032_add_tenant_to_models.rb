class AddTenantToModels < ActiveRecord::Migration
  def change
    remove_column :users, :admin
    remove_column :users, :portals_count
    add_column    :users, :role, :integer, default: 0
    add_reference :users, :account, index: true, foreign_key: true

    remove_reference :portals, :user
    add_reference :portals, :account, index: true, foreign_key: true

    add_reference :destinations, :account, index: true, foreign_key: true
    add_reference :submissions, :account, index: true, foreign_key: true
    add_reference :replies, :account, index: true, foreign_key: true
  end
end
