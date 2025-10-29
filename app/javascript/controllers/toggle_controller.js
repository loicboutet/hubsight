import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["toggleable"]
  static classes = ["active"]

  toggle() {
    this.toggleableTargets.forEach(target => {
      if (this.hasActiveClass) {
        target.classList.toggle(this.activeClass)
      } else {
        target.classList.toggle("show")
      }
    })
  }

  close() {
    this.toggleableTargets.forEach(target => {
      if (this.hasActiveClass) {
        target.classList.remove(this.activeClass)
      } else {
        target.classList.remove("show")
      }
    })
  }
}
