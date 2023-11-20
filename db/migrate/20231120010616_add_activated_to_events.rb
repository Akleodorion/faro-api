class AddActivatedToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :activated, :boolean
  end
end
