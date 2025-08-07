class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_authorized_or_sold, only: [:edit, :update]

  def show
  end

  def index
    @items = Item.includes(:user).order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.user == current_user
      @item.destroy
      redirect_to root_path, notice: '商品を削除しました'
    else
      redirect_to root_path, alert: '削除する権限がありません'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def redirect_if_not_authorized_or_sold
    return unless current_user != @item.user || @item.order.present?

    redirect_to root_path
  end

  def item_params
    params.require(:item).permit(
      :image, :title, :description, :category_id, :condition_id,
      :shipping_fee_bearer_id, :prefecture_id, :shipping_day_id, :price
    )
  end
end
