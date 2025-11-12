import { Controller } from "@hotwired/stimulus"

// Multi-select tags controller for handling tag-based multi-selection UI
export default class extends Controller {
  static targets = ["option", "badgesContainer", "hiddenInput"]
  static values = {
    options: Array,
    selected: Array,
    name: String
  }

  connect() {
    // Initialize selected items from data attribute or empty array
    if (!this.hasSelectedValue) {
      this.selectedValue = []
    }
    
    // Update display on connect
    this.updateBadges()
  }

  // Toggle selection when an option is clicked
  toggle(event) {
    const option = event.currentTarget
    const value = option.dataset.value
    
    if (this.selectedValue.includes(value)) {
      // Remove from selection
      this.selectedValue = this.selectedValue.filter(v => v !== value)
      option.classList.remove('selected')
    } else {
      // Add to selection
      this.selectedValue = [...this.selectedValue, value]
      option.classList.add('selected')
    }
    
    this.updateBadges()
  }

  // Remove a tag badge
  remove(event) {
    event.preventDefault()
    const value = event.currentTarget.dataset.value
    
    // Remove from selected values
    this.selectedValue = this.selectedValue.filter(v => v !== value)
    
    // Update option state
    const option = this.optionTargets.find(opt => opt.dataset.value === value)
    if (option) {
      option.classList.remove('selected')
    }
    
    this.updateBadges()
  }

  // Update the badges display based on selected values
  updateBadges() {
    if (!this.hasBadgesContainerTarget) return
    
    // Clear current badges
    this.badgesContainerTarget.innerHTML = ''
    
    // Create badge for each selected value
    this.selectedValue.forEach(value => {
      const badge = this.createBadge(value)
      this.badgesContainerTarget.appendChild(badge)
    })
    
    // Update hidden input if present (for form submission)
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = JSON.stringify(this.selectedValue)
    }
    
    // Show/hide badges container based on selection
    if (this.selectedValue.length > 0) {
      this.badgesContainerTarget.style.display = 'flex'
    } else {
      this.badgesContainerTarget.style.display = 'none'
    }
  }

  // Create a badge element
  createBadge(value) {
    const badge = document.createElement('span')
    badge.className = 'tag-badge'
    badge.innerHTML = `
      ${value}
      <button type="button" class="tag-badge-remove" data-action="click->multi-select-tags#remove" data-value="${value}">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    `
    return badge
  }

  // Update selected options visual state
  selectedValueChanged() {
    // Update all option states
    this.optionTargets.forEach(option => {
      const value = option.dataset.value
      if (this.selectedValue.includes(value)) {
        option.classList.add('selected')
      } else {
        option.classList.remove('selected')
      }
    })
  }
}
