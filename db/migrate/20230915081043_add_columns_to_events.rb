class AddColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :max_standard_ticket, :integer
    add_column :events, :standard_ticket_price, :integer
    add_column :events, :max_vip_ticket, :integer
    add_column :events, :vip_ticket_price, :integer
    add_column :events, :max_vvip_ticket, :integer
    add_column :events, :vvip_ticket_price, :integer
  end
end
