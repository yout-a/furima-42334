class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @items = Item.includes(:image_attachment).order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
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

  def edit
  end

  def update
  end

  def destroy
    item = Item.find(params[:id])
    if item.user == current_user
      item.destroy
      redirect_to root_path
    else
      redirect_to item_path(item), alert: '削除できません'
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
