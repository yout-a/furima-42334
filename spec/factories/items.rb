FactoryBot.define do
  factory :item do
    title { "テスト商品" }
    description { "これはテスト用の商品説明です" }
    price { 1000 }

    category_id { 2 }              # 1は"---"なので2以降
    condition_id { 2 }
    shipping_fee_bearer_id { 2 }
    prefecture_id { 2 }
    shipping_day_id { 2 }

    association :user              # 関連するuserを自動生成
    after(:build) do |item|
      item.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end
  end
end
