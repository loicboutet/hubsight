import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Bind the close method to this instance so we can remove it later
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
  }

  disconnect() {
    // Clean up event listener when controller disconnects
    document.removeEventListener("click", this.closeOnClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    
    if (this.menuTarget.classList.contains("show")) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.add("show")
    // Add click listener to close dropdown when clicking outside
    document.addEventListener("click", this.closeOnClickOutside)
  }

  close() {
    this.menuTarget.classList.remove("show")
    document.removeEventListener("click", this.closeOnClickOutside)
  }

  closeOnClickOutside(event) {
    // Close if click is outside the controller element
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}
