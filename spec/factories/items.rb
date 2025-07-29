FactoryBot.define do
  factory :item do
    title { "MyString" }
    description { "MyText" }
    price { 1 }
    category_id { 1 }
    condition_id { 1 }
    shipping_fee_bearer_id { 1 }
    prefecture_id { 1 }
    shipping_day_id { 1 }
    user { nil }
  end
end
