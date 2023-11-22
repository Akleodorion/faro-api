class EventSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :date, :location, :category, :free, :user_id, :max_standard_ticket ,
  :standard_ticket_description, :standard_ticket_price, :max_vip_ticket, :vip_ticket_description,
  :vip_ticket_price, :max_vvip_ticket, :vvip_ticket_description, :vvip_ticket_price, :photo_url, :latitude, :longitude, :activated

  has_many :members
  has_many :tickets

end
