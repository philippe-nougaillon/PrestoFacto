import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'source', 'selector', 'button' ]

  initialize() {
    this.selectorTarget.style.display = 'none';
    this.buttonTarget.style.display = 'none';
  }

  connect() {
    // console.log("Hello, Stimulus!", this.element)
  }
  click() {
    var check_boxes = this.sourceTargets;
    var enabled = check_boxes.filter(myFunction);
    
    function myFunction(value, index, array) {
      return value.checked;
    }
    //console.log(`Clicks = ${enabled.length}`)
    if (enabled.length == 0 ) {
      console.log(this.selectorTarget)
      console.log(this.buttonTarget)
      this.selectorTarget.style.display = 'none';
      this.buttonTarget.style.display = 'none';
    } else {
      this.selectorTarget.style.display = 'block';
      this.buttonTarget.style.display = 'block';
    }
  }
}
