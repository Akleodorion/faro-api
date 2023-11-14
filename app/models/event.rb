class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 50, maximum: 200 }
  validates :date, presence: true
  validates :location, presence: true # vérifier que la localisation existe bel est bien
  validates :category, inclusion: { in: %w[loisir concert sport culture] }

  attr_accessor :photo

  before_save :upload_photo_to_cloudinary, if: :photo_present?
  def photo_present?
    !photo.nil?
  end

  def upload_photo_to_cloudinary
    upload_result = Cloudinary::Uploader.upload(photo)
    self.photo_url = upload_result['secure_url']
  end
end
