import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  toggle() {
    this.sidebarTarget.classList.toggle("mobile-open")
    this.overlayTarget.classList.toggle("visible")
  }

  close() {
    this.sidebarTarget.classList.remove("mobile-open")
    this.overlayTarget.classList.remove("visible")
  }
}
