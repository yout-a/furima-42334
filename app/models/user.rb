class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  validates :nickname, presence: true

  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/
  validates :password,
            presence: true,
            length: { minimum: 6 },
            format: { with: VALID_PASSWORD_REGEX, message: 'は半角英数字混合で入力してください' }

  with_options presence: true, format: { with: /\A[ぁ-んァ-ン一-龥々ー・ヶヵゝゞヽヾ]+\z/, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' } do
    validates :last_name
    validates :first_name
  end

  with_options presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: 'は全角カタカナで入力してください' } do
    validates :last_name_kana
    validates :first_name_kana
  end

  validates :birth_date, presence: true
end
