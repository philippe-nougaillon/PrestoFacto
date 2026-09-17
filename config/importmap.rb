# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "bootstrap" # @5.3.8
# Fichier pris sur https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/+esm : la version jspm de bin/importmap importe des fichiers relatifs absents de vendor/
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/checkbox-select-all", to: "@stimulus-components--checkbox-select-all.js" # @6.1.0
pin "@stimulus-components/rails-nested-form", to: "@stimulus-components--rails-nested-form.js" # @5.0.0
