class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :user

  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_fee_bearer
  belongs_to :prefecture
  belongs_to :shipping_day

  has_one_attached :image

  with_options presence: true do
    validates :title
    validates :description
    validates :image
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
