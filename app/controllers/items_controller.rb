class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]




  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

    if @item.save
      redirect_to root_path, notice: '商品を出品しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :image, :title, :description, :category_id, :condition_id,
      :shipping_fee_bearer_id, :prefecture_id, :shipping_day_id, :price
    )
  end
end
