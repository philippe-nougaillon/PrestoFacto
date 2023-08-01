import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-forfaitaire"
export default class extends Controller {
  static targets = [ 'source', 'panel' ]

  initialize() {
    this.toggle();
  }
  connect() {
    // console.log("action_forfaitaire connecté !")
  }
  
  toggle() {
    var check_box = this.sourceTarget;
    // console.log(check_box.checked)
    this.panelTarget.style.display = (check_box.checked ? 'none' : 'block');
  }
}
