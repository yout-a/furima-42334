require 'rails_helper'

RSpec.describe OrderForm, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @order_form = FactoryBot.build(:order_form, user_id: @user.id, item_id: @item.id)
    sleep(0.1)
  end

  describe '購入内容の確認' do
    context '内容に問題がない場合' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@order_form).to be_valid
      end

      it 'buildingが空でも購入できる' do
        @order_form.building = ''
        expect(@order_form).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'tokenが空では購入できない' do
        @order_form.token = nil
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Token can't be blank")
      end

      it 'postal_codeが空では購入できない' do
        @order_form.postal_code = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Postal code can't be blank")
      end

      it 'postal_codeが「3桁-4桁」の形式でないと購入できない（ハイフンなし）' do
        @order_form.postal_code = '1234567'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Postal code is invalid. Input in half-width like 123-4567')
      end

      it 'postal_codeが全角だと購入できない' do
        @order_form.postal_code = '１２３-４５６７'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Postal code is invalid. Input in half-width like 123-4567')
      end

      it 'prefecture_idが0だと購入できない' do
        @order_form.prefecture_id = 0
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Prefecture can't be blank")
      end

      it 'cityが空では購入できない' do
        @order_form.city = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("City can't be blank")
      end

      it 'addressが空では購入できない' do
        @order_form.address = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Address can't be blank")
      end

      it 'phone_numberが空では購入できない' do
        @order_form.phone_number = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Phone number can't be blank")
      end

      it 'phone_numberにハイフンが含まれていると購入できない' do
        @order_form.phone_number = '090-1234-5678'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Phone number is invalid. Input 10 or 11 digit half-width numbers without hyphens')
      end

      it 'phone_numberが9桁以下だと購入できない' do
        @order_form.phone_number = '090123456'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Phone number is invalid. Input 10 or 11 digit half-width numbers without hyphens')
      end

      it 'phone_numberが12桁以上だと購入できない' do
        @order_form.phone_number = '090123456789'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Phone number is invalid. Input 10 or 11 digit half-width numbers without hyphens')
      end

      it 'phone_numberが全角数字だと購入できない' do
        @order_form.phone_number = '０９０１２３４５６７８'
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include('Phone number is invalid. Input 10 or 11 digit half-width numbers without hyphens')
      end

      it 'user_idが空だと購入できない' do
        @order_form.user_id = nil
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空だと購入できない' do
        @order_form.item_id = nil
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
