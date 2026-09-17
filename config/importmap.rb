# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/checkbox-select-all", to: "@stimulus-components--checkbox-select-all.js" # @6.1.0
pin "@stimulus-components/rails-nested-form", to: "@stimulus-components--rails-nested-form.js" # @5.0.0
pin "stimulus-notification" # @2.2.0
pin "stimulus-use" # @0.51.3
pin "hotkeys-js" # @3.13.7
