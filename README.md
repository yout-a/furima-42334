# README

#テーブル設計


## Users テーブル

| Column            | Type     | Options          |
| ----------------- | -------- | ---------------- |
| id                | bigint   | PK, NOT NULL     |
| nickname          | string   | NOT NULL         |
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
* has_many :orders, foreign_key: :user_id

## Items テーブル

| Column                 | Type       | Options                                           |
| ---------------------- | ---------- | ------------------------------------------------- |
| id                     | bigint     | PK, NOT NULL                                      |
| title                  | string     | NOT NULL                                          |
| description            | text       | NOT NULL                                          |
| price                  | integer    | NOT NULL,                                         |
| status_id              | integer    | NOT NULL                                          |
| category_id            | integer    | NOT NULL                                          |
| condition_id           | integer    | NOT NULL                                          |
| shipping_fee_bearer_id | integer    | NOT NULL                                          |
| prefecture_id          | integer    | NOT NULL                                          |
| shipping_day_id        | integer    | NOT NULL                                          |
| user                   | references | NOT NULL, foreign_key: true, index                |
| created_at             | datetime   | NOT NULL                                          |
| updated_at             | datetime   | NOT NULL                                          |

### Association

* belongs_to :user
* has_many :orders

## orders テーブル

| Column          | Type       | Options                            |
| --------------- | ---------- | ---------------------------------- |
| id              | bigint     | PK, NOT NULL                       |
| item            | references | NOT NULL, foreign_key: true, index |
| user            | references | NOT NULL, foreign_key: true, index |
| quantity        | integer    | NOT NULL, default: 1               |
| purchase_price  | integer    | NOT NULL,                          |
| status          | string     | NOT NULL, default: "pending"       |
| created_at      | datetime   | NOT NULL                           |
| updated_at      | datetime   | NOT NULL                           |

### Association

* belongs_to :item
* belongs_to :user
* has_one :delivery

## Deliveries テーブル

| Column         | Type       | Options                               |
| -------------- | --------   | ------------------------------------- |
| id             | bigint     | PK, NOT NULL                          |
| order          | references | NOT NULL, foreign_key: true, index    |
| postal_code    | string     | NOT NULL, format: XXX-XXXX            |
| prefecture     | references | NOT NULL, foreign_key: true, index    |
| city           | string     | NOT NULL                              |
| address        | string     | NOT NULL                              |
| building       | string     |                                       |
| phone_number   | string     | NOT NULL, format: 10–11 digit         |
| created_at     | datetime   | NOT NULL                              |
| updated_at     | datetime   | NOT NULL                              |

### Association

* belongs_to :order
