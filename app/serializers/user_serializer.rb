class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username, :phone_number
end
