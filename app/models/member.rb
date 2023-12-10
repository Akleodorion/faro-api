class Member < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id ,message: "Le contact est déjà membre de l'évènement."}
end
