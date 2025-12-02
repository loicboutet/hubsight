import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Auto-dismiss flash messages after 5 seconds
    this.messageTargets.forEach(message => {
      setTimeout(() => {
        this.dismissMessage(message)
      }, 5000)
    })
  }

  dismiss(event) {
    this.dismissMessage(event.currentTarget.closest('.flash-message'))
  }

  dismissMessage(message) {
    message.classList.add('dismissing')
    setTimeout(() => {
      message.remove()
      
      // If no more messages, remove the container
      if (this.messageTargets.length === 0) {
        this.element.remove()
      }
    }, 300)
  }
}
