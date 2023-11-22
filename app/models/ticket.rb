class Ticket < ApplicationRecord
  self.inheritance_column = :_non_existent_column
  belongs_to :user
  belongs_to :event

end
