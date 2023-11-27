class RenameLocationToCountry < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :location, :country
  end
end
