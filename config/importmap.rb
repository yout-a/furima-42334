# アプリケーションのエントリポイント
pin "application", preload: true

# Hotwire Turbo (data-turbo-method を解釈するために必須)
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16

# # # Stimulus 本体
pin "@hotwired/stimulus",        to: "stimulus.min.js",        preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# controllers 以下をまとめてピン
pin_all_from "app/javascript/controllers", under: "controllers"


pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.13
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.0.200
