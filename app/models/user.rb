class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネーム必須
  validates :nickname, presence: true

  # 氏名（漢字・ひらがな・カタカナ）
  with_options presence: true, format: { with: /\A[ぁ-んァ-ン一-龥々ー]+\z/, message: "は全角（漢字・ひらがな・カタカナ）で入力してください" } do
    validates :last_name
    validates :first_name
  end

  # 氏名カナ（カタカナ）
  with_options presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" } do
    validates :last_name_kana
    validates :first_name_kana
  end

  # 生年月日
  validates :birth_date, presence: true
end

