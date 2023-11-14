class AddNewColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
    add_column :events, :standard_ticket_description, :string
    add_column :events, :vip_ticket_description, :string
    add_column :events, :vvip_ticket_description, :string
  end
end
