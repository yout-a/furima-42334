FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.last_name }
    email                 { Faker::Internet.email }

    transient do
      fixed_password { 'abc123' }
    end

    password              { fixed_password }
    password_confirmation { fixed_password }

    last_name             { '山田' }
    first_name            { '太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birth_date            { '1990-01-01' }
  end
end
