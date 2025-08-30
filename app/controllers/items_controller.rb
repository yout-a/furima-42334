class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :destroy_image]
  before_action :ensure_editable, only: [:edit, :update, :destroy, :destroy_image]

  def index
    @items = Item.includes(images_attachments: :blob).order(created_at: :desc)
  end

  def show; end

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

  def edit; end

  def update
  @item.assign_attributes(item_params_without_images)

  before = @item.images.attachments.to_a   # 既存を記録

  # 置き換え
  if params.dig(:item, :replace_images).present?
    params[:item][:replace_images].each do |att_id, uploaded|
      next if uploaded.blank?
      if (old = @item.images.attachments.find_by(id: att_id))
        old.purge
      end
      @item.images.attach(uploaded)
    end
  end

  # 個別削除
  if params[:item][:remove_image_ids].present?
    @item.images.attachments.where(id: params[:item][:remove_image_ids]).each(&:purge)
  end

  # 追加
  @item.images.attach(params[:item][:images]) if params.dig(:item, :images).present?

  if @item.save
    redirect_to @item, notice: "商品を更新しました。"
  else
    # 失敗時：今回追加された分だけ戻す（次の描画で“6枚”などにならない）
    newly = @item.images.attachments - before
    newly.each(&:purge)

    @item.images_attachments.reload
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

  def destroy_image
    attachment = @item.images.attachments.find(params[:attachment_id])
    attachment.purge

    respond_to do |format|
      format.turbo_stream # Turbo(Hotwire)でカードをその場で消す
      format.html { redirect_to edit_item_path(@item), notice: '画像を削除しました。' }
      format.json { head :no_content }
    end
  end

  private

  def set_item
     @item = Item.find(params[:id] || params[:item_id])
  end

  def ensure_editable
    redirect_to root_path, alert: '権限がありません' and return unless @item.user == current_user && !@item.order.present?
  end

  def item_params
  params.require(:item).permit(
    :title, :description, :price,
    :category_id, :condition_id, :shipping_fee_bearer_id,
    :prefecture_id, :shipping_day_id,
    { images: [] }
    )
  end

  def item_params_without_images
  params.require(:item).permit(
    :title, :description, :price,
    :category_id, :condition_id, :shipping_fee_bearer_id,
    :prefecture_id, :shipping_day_id
    )
  end
end
