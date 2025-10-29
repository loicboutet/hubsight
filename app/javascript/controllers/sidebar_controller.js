import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    // Listen for turbo:before-cache to cleanup state before caching
    this.beforeCacheHandler = this.beforeCache.bind(this)
    document.addEventListener("turbo:before-cache", this.beforeCacheHandler)
  }

  disconnect() {
    // Remove event listener when controller disconnects
    document.removeEventListener("turbo:before-cache", this.beforeCacheHandler)
  }

  toggle() {
    this.sidebarTarget.classList.toggle("mobile-open")
    this.overlayTarget.classList.toggle("visible")
  }

  close() {
    this.sidebarTarget.classList.remove("mobile-open")
    this.overlayTarget.classList.remove("visible")
  }

  beforeCache() {
    // Clean up state before Turbo caches the page
    this.close()
  }
}
