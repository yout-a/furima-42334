class OrdersController < ApplicationController
require "payjp"


  def index
    @item = Item.find(params[:item_id])
    if current_user.id == @item.user_id || @item.order.present?
      redirect_to root_path
    end
    @order_form = OrderForm.new
  end

  def create
    @item = Item.find(params[:item_id])
    @order_form = OrderForm.new(order_params.merge(price: @item.price)) 

    if @order_form.valid?
      pay_item
      @order_form.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_form).permit(
      :postal_code, :prefecture_id, :city, :address, :building, :phone_number
    ).merge(
      user_id: current_user.id,
      item_id: @item.id,
      token: params[:token]
    )
  end

  def pay_item
  Payjp.api_key = ENV["PAYJP_SECRET_KEY"] 
  Payjp::Charge.create(
    amount: @item.price,             
    card: order_params[:token],      
    currency: 'jpy'                 
  )
  end
end

