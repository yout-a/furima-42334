class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  def sold_out?
    order.present?
  end

  belongs_to :user
  has_one :order

  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_fee_bearer
  belongs_to :prefecture
  belongs_to :shipping_day

  MAX_IMAGES = 5

  has_many_attached :images
  validates :images,
    attached: true,
    content_type: %w[image/png image/jpeg],
    limit: { min: 1, max: MAX_IMAGES }

  with_options presence: true do
    validates :title
    validates :description
    validates :price
    validates :category_id
    validates :condition_id
    validates :shipping_fee_bearer_id
    validates :prefecture_id
    validates :shipping_day_id
  end

  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
  validates :category_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :condition_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :shipping_fee_bearer_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :shipping_day_id, numericality: { other_than: 1, message: 'を選択してください' }
end


