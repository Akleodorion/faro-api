class AddQrCodeToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :qr_code_url, :string
  end
end
