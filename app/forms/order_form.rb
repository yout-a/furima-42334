class OrderForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id,
                :postal_code, :prefecture_id, :city, :address, :building, :phone_number,
                :token, :price

  with_options presence: true do
  validates :user_id
  validates :item_id
  validates :postal_code, format: {
    with: /\A\d{3}-\d{4}\z/,
    message: "is invalid. Input in half-width like 123-4567"
  }
  validates :city
  validates :address
  validates :phone_number, format: {
    with: /\A\d{10,11}\z/,
    message: "is invalid. Input 10 or 11 digit half-width numbers without hyphens"
  }
  validates :token
end

validates :prefecture_id, numericality: { other_than: 0, message: "can't be blank" }

  def save
    order = Order.create(user_id: user_id, item_id: item_id, price: price)
    Delivery.create(
      order_id: order.id,
      postal_code: postal_code,
      prefecture_id: prefecture_id,
      city: city,
      address: address,
      building: building,
      phone_number: phone_number
    )
  end
end
