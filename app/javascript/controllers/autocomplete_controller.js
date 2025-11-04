import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "suggestions", "container"]
  static values = {
    items: Array
  }

  connect() {
    // Dummy data for purchase subfamilies
    this.allItems = [
      "Maintenance",
      "Nettoyage",
      "Espaces verts",
      "Sécurité",
      "Contrôle technique",
      "Plomberie",
      "Électricité",
      "CVC - Chauffage",
      "CVC - Ventilation",
      "CVC - Climatisation",
      "Ascenseurs",
      "GTB/GTC",
      "Désenfumage",
      "SSI - Système de Sécurité Incendie",
      "Électricité CFO/CFA",
      "Portes automatiques",
      "Menuiserie",
      "Peinture",
      "Maçonnerie",
      "Vitres et façades"
    ]
    
    // Track selected items to prevent duplicates
    this.selectedItems = new Set()
    
    // Bind methods
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside)
  }

  // Filter suggestions based on input
  filter(event) {
    const query = this.inputTarget.value.toLowerCase().trim()
    
    if (query.length === 0) {
      this.hideSuggestions()
      return
    }
    
    // Filter items that match the query and aren't already selected
    const filtered = this.allItems.filter(item => 
      item.toLowerCase().includes(query) && !this.selectedItems.has(item)
    )
    
    this.showSuggestions(filtered)
  }

  // Show filtered suggestions
  showSuggestions(items) {
    if (items.length === 0) {
      this.hideSuggestions()
      return
    }
    
    this.suggestionsTarget.innerHTML = items.map(item => `
      <div class="autocomplete-suggestion-item" data-action="click->autocomplete#select" data-value="${item}">
        ${item}
      </div>
    `).join('')
    
    this.suggestionsTarget.style.display = 'block'
    
    // Add click listener to close on outside click
    setTimeout(() => {
      document.addEventListener("click", this.closeOnClickOutside)
    }, 0)
  }

  // Hide suggestions
  hideSuggestions() {
    this.suggestionsTarget.style.display = 'none'
    document.removeEventListener("click", this.closeOnClickOutside)
  }

  // Select an item from suggestions
  select(event) {
    const value = event.currentTarget.dataset.value
    
    // Add to selected items
    this.selectedItems.add(value)
    
    // Add badge to container
    this.addBadge(value)
    
    // Clear input and hide suggestions
    this.inputTarget.value = ''
    this.hideSuggestions()
    
    // Focus back on input
    this.inputTarget.focus()
  }

  // Add a badge to the container
  addBadge(text) {
    const badge = document.createElement('span')
    badge.className = 'autocomplete-badge'
    badge.innerHTML = `
      ${text}
      <button type="button" class="autocomplete-badge-remove" data-action="click->autocomplete#remove" data-value="${text}">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    `
    
    this.containerTarget.appendChild(badge)
  }

  // Remove a selected badge
  remove(event) {
    event.preventDefault()
    const value = event.currentTarget.dataset.value
    const badge = event.currentTarget.closest('.autocomplete-badge')
    
    // Remove from selected items
    this.selectedItems.delete(value)
    
    // Remove badge from DOM
    badge.remove()
  }

  // Close suggestions when clicking outside
  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideSuggestions()
    }
  }

  // Handle keyboard navigation
  keydown(event) {
    if (event.key === 'Escape') {
      this.hideSuggestions()
    }
  }
}
