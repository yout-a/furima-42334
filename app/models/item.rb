class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :user
  has_many :orders

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
  end

  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
  validates :category_id, numericality: { other_than: 1 , message: "を選択してください" }
  validates :shipping_fee_bearer_id, numericality: { other_than: 1, message: "を選択してください" }  # ← 追加
  validates :prefecture_id, numericality: { other_than: 1, message: "を選択してください" }        # ← 後で必要
  validates :shipping_day_id, numericality: { other_than: 1, message: "を選択してください" }       # ← 後で必要
end


