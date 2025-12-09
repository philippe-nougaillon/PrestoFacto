import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-allergie"
export default class extends Controller {
  static targets = ['source', 'field']

  initialize() {
    this.toggle();
  }
  connect() {
    console.log("toggle-allergie connecté !")
  }

  toggle() {
    console.log(this.sourceTarget.checked)
    if (this.sourceTarget.checked) {
      this.fieldTarget.required = true
    }else {
      this.fieldTarget.required = false
    }
  }
}
