class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_invalid_access, only: [:index, :create]
  before_action :set_payjp_public_key, only: [:index, :create]

  require "payjp"

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]

    unless user_signed_in?
      return redirect_to root_path
    end

    if current_user.id == @item.user_id || @item.order.present?
      return redirect_to root_path
    end

    @order_form = OrderForm.new
  end

  def create
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

  def set_item
    @item = Item.find(params[:item_id])
  end

  def redirect_if_invalid_access
    if current_user.id == @item.user_id || @item.order.present?
      redirect_to root_path
    end
  end

  def set_payjp_public_key
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
  end

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

  def set_gon_key
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
  end
end

