class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string     :title
      t.text       :description
      t.integer    :price
      t.integer    :category_id, null: false
      t.integer    :condition_id, null: false
      t.integer    :shipping_fee_bearer_id, null: false
      t.integer    :prefecture_id, null: false
      t.integer    :shipping_day_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

