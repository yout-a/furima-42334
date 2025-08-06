# アプリケーションのエントリポイント
pin "application", preload: true

# Hotwire-Turbo（data-turbo-method を解釈するために必要）
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.13

# Stimulus 本体
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# controllers: 以下をまとめてピン
pin_all_from "app/javascript/controllers", under: "controllers"

# rails/actioncable
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.0.200

pin "item_price", to: "item_price.js"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "card", to: "card.js"
