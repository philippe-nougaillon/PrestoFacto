# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-rails-nested-form", to: "https://ga.jspm.io/npm:stimulus-rails-nested-form@4.1.0/dist/stimulus-rails-nested-form.mjs"
pin "stimulus-checkbox-select-all", to: "https://ga.jspm.io/npm:stimulus-checkbox-select-all@5.3.0/dist/stimulus-checkbox-select-all.mjs"
pin "stimulus-notification" # @2.2.0
pin "stimulus-use" # @0.51.3
pin "hotkeys-js" # @3.13.7
