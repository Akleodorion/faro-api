class AddAddressesColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :country_code, :string
    add_column :events, :locality, :string
    add_column :events, :sublocality, :string
    add_column :events, :road, :string
    add_column :events, :plus_code, :string
  end
end
