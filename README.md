# README

#テーブル設計


## Users テーブル

| Column             | Type     | Options                  |
| ------------------ | -------- | ------------------------ |
| nickname           | string   | null:false               |
| email              | string   | null:false, unique: true |
| encrypted_password | string   | null:false               |
| last_name          | string   | null:false               |
| first_name         | string   | null:false               |
| last_name_kana     | string   | null:false               |
| first_name_kana    | string   | null:false               |
| birth_date         | date     | null:false               |

### Association

* has_many :items
* has_many :orders

## Items テーブル

| Column                 | Type       | Options                       |
| ---------------------- | ---------- | ----------------------------- |
| title                  | string     | null:false                    |
| description            | text       | null:false                    |
| price                  | integer    | null:false                    |
| category_id            | integer    | null:false                    |
| condition_id           | integer    | null:false                    |
| shipping_fee_bearer_id | integer    | null:false                    |
| prefecture_id          | integer    | null:false                    |
| shipping_day_id        | integer    | null:false                    |
| user                   | references | null:false, foreign_key: true |

### Association

* belongs_to :user
* has_many :orders

## orders テーブル

| Column          | Type       | Options                       |
| --------------- | ---------- | ----------------------------- |
| item            | references | null:false, foreign_key: true |
| user            | references | null:false, foreign_key: true |

### Association

* belongs_to :item
* belongs_to :user
* has_one :delivery


## Deliveries テーブル

| Column         | Type       | Options                               |
| -------------- | --------   | ------------------------------------- |
| order          | references | null:false, foreign_key: true         |
| postal_code    | string     | null:false,                           |
| prefecture_id  | integer    | null:false                            |
| city           | string     | null:false                            |
| address        | string     | null:false                            |
| building       | string     |                                       |
| phone_number   | string     | null:false,                           |

### Association

* belongs_to :order
