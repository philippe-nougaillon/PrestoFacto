import { Controller, Application } from "@hotwired/stimulus"
import CheckboxSelectAll from 'stimulus-checkbox-select-all'

const application = Application.start()
application.register('checkbox-select-all', CheckboxSelectAll)

// Connects to data-controller="checkbox-select-all"
export default class extends Controller {
  connect() {
    // console.log("Hello, Stimulus checkbox-select-all!", this.element)
  }
}
