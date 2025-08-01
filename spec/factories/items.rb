FactoryBot.define do
  factory :item do
    title { 'テスト商品' }
    description { 'これはテスト用の商品説明です' }
    price { 1000 }

    category_id { 2 }
    condition_id { 2 }
    shipping_fee_bearer_id { 2 }
    prefecture_id { 2 }
    shipping_day_id { 2 }

    association :user
    after(:build) do |item|
      item.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end
  end
end
