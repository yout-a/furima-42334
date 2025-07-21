# README

#テーブル設計


## Users テーブル

| Column            | Type     | Options          |
| ----------------- | -------- | ---------------- |
| id                | bigint   | PK, NOT NULL     |
| nickname          | string   | NOT NULL, UNIQUE |
| email             | string   | NOT NULL, UNIQUE |
| password          | string   | NOT NULL         |
| last_name         | string   | NOT NULL         |
| first_name        | string   | NOT NULL         |
| last_name_kana    | string   | NOT NULL         |
| first_name_kana   | string   | NOT NULL         |
| birth_date        | date     | NOT NULL         |
| created_at        | datetime | NOT NULL         |
| updated_at        | datetime | NOT NULL         |

### Association

* has_many :items
* has_many :orders, foreign_key: :buyer_id

## Items テーブル

| Column                | Type     | Options                                           |
| --------------------- | -------- | ------------------------------------------------- |
| id                    | bigint   | PK, NOT NULL                                      |
| title                 | string   | NOT NULL                                          |
| description           | text     | NOT NULL                                          |
| price                 | integer  | NOT NULL, range: 300–9,999,999                    |
| status                | string   | NOT NULL, default: "available"                    |
| category_id           | integer  | NOT NULL, FK → categories.id, INDEX              |
| condition_id          | integer  | NOT NULL, FK → conditions.id, INDEX              |
| shipping_fee_bearer   | integer  | NOT NULL, inclusion: [0:buyer,1:seller,2:cod]     |
| prefecture_id         | integer  | NOT NULL, FK → prefectures.id, INDEX             |
| shipping_day_id       | integer  | NOT NULL                                          |
| user_id               | bigint   | NOT NULL, FK → users.id, INDEX                   |
| created_at            | datetime | NOT NULL                                          |
| updated_at            | datetime | NOT NULL                                          |

### Association

* belongs_to :user
* has_many :orders

## Orders テーブル

| Column          | Type     | Options                         |
| --------------- | -------- | ------------------------------  |
| id              | bigint   | PK, NOT NULL                    |
| item_id         | bigint   | NOT NULL, FK → items.id, INDEX |
| buyer_id        | bigint   | NOT NULL, FK → users.id, INDEX |
| quantity        | integer  | NOT NULL, default: 1            |
| purchase_price  | integer  | NOT NULL, range: 300–9,999,999  |
| status          | string   | NOT NULL, default: "pending"    |
| created_at      | datetime | NOT NULL                        |
| updated_at      | datetime | NOT NULL                        |

### Association

* belongs_to :item
* belongs_to :buyer, class_name: "User"
* has_one :delivery

## Deliveries テーブル

| Column         | Type     | Options                               |
| -------------- | -------- | ------------------------------------- |
| id             | bigint   | PK, NOT NULL                          |
| order_id       | bigint   | NOT NULL, FK → orders.id, INDEX      |
| postal_code    | string   | NOT NULL, format: XXX-XXXX            |
| prefecture_id  | integer  | NOT NULL, FK → prefectures.id, INDEX |
| city           | string   | NOT NULL                              |
| address        | string   | NOT NULL                              |
| building       | string   |                                       |
| phone_number   | string   | NOT NULL, format: 10–11 digit         |
| created_at     | datetime | NOT NULL                              |
| updated_at     | datetime | NOT NULL                              |

### Association

* belongs_to :order
