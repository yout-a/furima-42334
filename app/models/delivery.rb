# app/models/delivery.rb
class Delivery < ApplicationRecord
  belongs_to :order
end
