class Event < ApplicationRecord
  belongs_to :user

  validates :name, presence: true # ajouter une longueur minimum
  validates :description, presence: true # ajouter une longeur minimum
  validates :date, presence: true # une vérification que la date est entrée est > que la date d'ajourd'hui
  validates :location, presence: true # vérifier que la localisation existe bel est bien
  validates :category, presence: true # vérifier que la category fait parti de la liste des Enum choisis
end
