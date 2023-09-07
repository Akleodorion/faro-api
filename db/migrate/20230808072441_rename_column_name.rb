class RenameColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :name, :username, unique: true
  end
end