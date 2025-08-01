require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品' do
        context '出品できる場合' do
      it 'すべての項目が正しく入力されていれば保存できる' do
        expect(@item).to be_valid
      end

      it '価格が300円ちょうどでも保存できる' do
        @item.price = 300
        expect(@item).to be_valid
      end

      it '価格が9,999,999円ちょうどでも保存できる' do
        @item.price = 9_999_999
        expect(@item).to be_valid
      end

      it 'カテゴリーが1以外であれば保存できる' do
        @item.category_id = 2
        expect(@item).to be_valid
      end

      it '商品の状態が1以外であれば保存できる' do
        @item.condition_id = 2
        expect(@item).to be_valid
      end

      it '配送料の負担が1以外であれば保存できる' do
        @item.shipping_fee_bearer_id = 2
        expect(@item).to be_valid
      end

      it '発送元の地域が1以外であれば保存できる' do
        @item.prefecture_id = 2
        expect(@item).to be_valid
      end

      it '発送までの日数が1以外であれば保存できる' do
        @item.shipping_day_id = 2
        expect(@item).to be_valid
      end

      it '画像が添付されていれば保存できる' do
        @item.image = fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.png'), 'test_image.png')
        expect(@item).to be_valid
      end

      it 'userが紐づいていれば保存できる' do
        expect(@item.user).to be_present
        expect(@item).to be_valid
      end
    end

    context '出品できない場合' do
      it '画像が空では保存できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end

      it '商品名が空では保存できない' do
        @item.title = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Title can't be blank")
      end

      it '商品説明が空では保存できない' do
        @item.description = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Description can't be blank")
      end

      it 'カテゴリーが「---」では保存できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Category を選択してください")
      end

      it '商品の状態が「---」では保存できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Condition を選択してください")
      end

      it '配送料の負担が「---」では保存できない' do
        @item.shipping_fee_bearer_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Shipping fee bearer を選択してください")
      end

      it '発送元の地域が「---」では保存できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Prefecture を選択してください")
      end

      it '発送までの日数が「---」では保存できない' do
        @item.shipping_day_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Shipping day を選択してください")
      end

      it '価格が空では保存できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end

      it '価格が300未満では保存できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include("Price must be greater than or equal to 300")
      end

      it '価格が9,999,999より大きいと保存できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include("Price must be less than or equal to 9999999")
      end

      it '価格が全角数値では保存できない' do
        @item.price = '３００'
        @item.valid?
        expect(@item.errors.full_messages).to include("Price is not a number")
      end

      it '価格が英字では保存できない' do
        @item.price = 'abc'
        @item.valid?
        expect(@item.errors.full_messages).to include("Price is not a number")
      end

      it '価格が英数混合では保存できない' do
        @item.price = '300yen'
        @item.valid?
        expect(@item.errors.full_messages).to include("Price is not a number")
      end

      it 'userが紐付いていないと保存できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("User must exist")
      end
    end
  end
end

