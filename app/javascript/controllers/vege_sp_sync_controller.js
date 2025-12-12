import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vege-sp-sync"
export default class extends Controller {
  static targets = ['vege', 'sp']

  initialize() {
    this.sync();
  }
  connect() {
    console.log("vege-sp-sync connecté !")
  }

  sync() {
    if (this.vegeTarget.checked) {
      this.spTarget.checked = true;
      this.spTarget.parentElement.title = "Ne peut pas être décoché lorsque le menu végétarien est coché";
      this.spTarget.parentElement.style = "cursor: not-allowed;"
      for (let child of this.spTarget.parentElement.children) {
        child.style = "cursor: not-allowed;"
      }
    } else {
      this.spTarget.parentElement.removeAttribute("title");
      this.spTarget.parentElement.style = "cursor: default;"
      for (let child of this.spTarget.parentElement.children) {
        child.style = "cursor: default;"
      }
    }
  }

  toggleVege() {
    this.sync()
  }

  toggleSP(event) {
    // Si vege est coché, on interdit de décocher sp
    if (this.vegeTarget.checked && !this.spTarget.checked) {
      event.preventDefault()
      this.spTarget.checked = true
    }
  }
}
