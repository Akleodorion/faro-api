class RenameColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :max_vip_ticket, :max_gold_ticket
    rename_column :events, :vip_ticket_price, :gold_ticket_price
    rename_column :events, :vip_ticket_description, :gold_ticket_description
    rename_column :events, :max_vvip_ticket, :max_platinum_ticket
    rename_column :events, :vvip_ticket_price, :platinum_ticket_price
    rename_column :events, :vvip_ticket_description, :platinum_ticket_description
  end
end
