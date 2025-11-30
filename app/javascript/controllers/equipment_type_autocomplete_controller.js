import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "hiddenField",
    "suggestions",
    "filterButtons",
    "selectedInfo",
    "loadingIndicator"
  ]
  
  static values = {
    url: { type: String, default: "/api/equipment_types/autocomplete" }
  }
  
  connect() {
    console.log("Equipment Type Autocomplete controller connected")
    this.selectedLot = null
    this.debounceTimeout = null
    this.selectedIndex = -1
    this.equipmentTypes = []
    
    // Close dropdown when clicking outside
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.boundHandleClickOutside)
  }
  
  disconnect() {
    document.removeEventListener("click", this.boundHandleClickOutside)
    if (this.debounceTimeout) {
      clearTimeout(this.debounceTimeout)
    }
  }
  
  // Search with debouncing
  search(event) {
    const query = this.inputTarget.value.trim()
    
    // Clear previous timeout
    if (this.debounceTimeout) {
      clearTimeout(this.debounceTimeout)
    }
    
    // Reset selected index
    this.selectedIndex = -1
    
    // If query is too short, hide suggestions
    if (query.length < 2) {
      this.hideSuggestions()
      this.hideSelectedInfo()
      return
    }
    
    // Show loading indicator
    this.showLoading()
    
    // Debounce the API call (300ms)
    this.debounceTimeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }
  
  // Perform the actual API search
  async performSearch(query) {
    try {
      // Build query parameters
      const params = new URLSearchParams({ query })
      if (this.selectedLot) {
        params.append('technical_lot', this.selectedLot)
      }
      
      // Fetch data from API
      const response = await fetch(`${this.urlValue}?${params}`)
      if (!response.ok) throw new Error('API request failed')
      
      const data = await response.json()
      this.equipmentTypes = data
      
      // Hide loading
      this.hideLoading()
      
      // Display results
      if (data.length > 0) {
        this.showSuggestions(data)
      } else {
        this.showNoResults()
      }
    } catch (error) {
      console.error('Error fetching equipment types:', error)
      this.hideLoading()
      this.showError()
    }
  }
  
  // Filter by technical lot
  filterByLot(event) {
    event.preventDefault()
    const button = event.currentTarget
    const lot = button.dataset.lot
    
    // Toggle selection
    if (this.selectedLot === lot) {
      this.selectedLot = null
      this.clearFilterSelection()
    } else {
      this.selectedLot = lot
      this.updateFilterSelection(button)
    }
    
    // Re-search with current query
    const query = this.inputTarget.value.trim()
    if (query.length >= 2) {
      this.performSearch(query)
    }
  }
  
  // Update filter button appearance
  updateFilterSelection(selectedButton) {
    // Remove active class from all buttons
    if (this.hasFilterButtonsTarget) {
      const buttons = this.filterButtonsTarget.querySelectorAll('button')
      buttons.forEach(btn => {
        btn.classList.remove('active')
        btn.style.backgroundColor = ''
        btn.style.color = ''
        btn.style.borderColor = ''
      })
      
      // Add active class to selected
      selectedButton.classList.add('active')
      selectedButton.style.backgroundColor = '#667eea'
      selectedButton.style.color = 'white'
      selectedButton.style.borderColor = '#667eea'
    }
  }
  
  // Clear filter selection
  clearFilterSelection() {
    if (this.hasFilterButtonsTarget) {
      const buttons = this.filterButtonsTarget.querySelectorAll('button')
      buttons.forEach(btn => {
        btn.classList.remove('active')
        btn.style.backgroundColor = ''
        btn.style.color = ''
        btn.style.borderColor = ''
      })
    }
  }
  
  // Show suggestions dropdown
  showSuggestions(equipmentTypes) {
    if (!this.hasSuggestionsTarget) return
    
    this.suggestionsTarget.innerHTML = ""
    
    equipmentTypes.forEach((type, index) => {
      const item = this.createSuggestionItem(type, index)
      this.suggestionsTarget.appendChild(item)
    })
    
    this.suggestionsTarget.style.display = "block"
  }
  
  // Create a single suggestion item
  createSuggestionItem(type, index) {
    const item = document.createElement("div")
    item.className = "autocomplete-suggestion-item"
    item.dataset.index = index
    item.style.cssText = `
      padding: 12px 16px;
      cursor: pointer;
      border-bottom: 1px solid #e9ecef;
      transition: background-color 0.2s;
    `
    
    // Get badge color
    const badgeColor = this.getBadgeColor(type.lot_badge_color)
    
    // Build HTML
    item.innerHTML = `
      <div style="display: flex; align-items: center; gap: 12px;">
        <div style="
          background: ${badgeColor};
          color: white;
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 11px;
          font-weight: 600;
          min-width: 40px;
          text-align: center;
        ">
          ${type.technical_lot_trigram}
        </div>
        <div style="flex: 1;">
          <div style="font-weight: 600; color: #2c3e50; margin-bottom: 2px;">
            ${type.code} - ${type.name}
          </div>
          ${this.buildSubtitle(type)}
        </div>
      </div>
    `
    
    // Event listeners
    item.addEventListener("mouseenter", () => {
      this.selectedIndex = index
      this.updateHighlight()
    })
    item.addEventListener("click", () => this.select(type))
    
    return item
  }
  
  // Build subtitle with function and characteristics
  buildSubtitle(type) {
    const parts = []
    
    if (type.function) {
      parts.push(type.function)
    }
    
    if (type.purchase_subfamily) {
      parts.push(type.purchase_subfamily)
    }
    
    if (parts.length === 0) {
      return ''
    }
    
    return `<div style="color: #6c757d; font-size: 0.875rem; margin-top: 2px;">
      ${parts.join(' • ')}
    </div>`
  }
  
  // Get color for badge
  getBadgeColor(colorName) {
    const colors = {
      blue: '#3b82f6',
      yellow: '#f59e0b',
      cyan: '#06b6d4',
      red: '#ef4444',
      purple: '#a855f7',
      green: '#10b981',
      orange: '#f97316',
      indigo: '#6366f1',
      gray: '#6b7280'
    }
    return colors[colorName] || colors.gray
  }
  
  // Show no results message
  showNoResults() {
    if (!this.hasSuggestionsTarget) return
    
    this.suggestionsTarget.innerHTML = `
      <div style="padding: 24px; text-align: center; color: #6c757d;">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="margin: 0 auto 12px; opacity: 0.5;">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p style="margin: 0 0 8px; font-weight: 600;">Aucun type d'équipement trouvé</p>
        <p style="margin: 0; font-size: 0.875rem;">
          ${this.selectedLot ? 'Essayez avec un autre lot technique ou ' : ''}
          Essayez une autre recherche
        </p>
      </div>
    `
    this.suggestionsTarget.style.display = "block"
  }
  
  // Show error message
  showError() {
    if (!this.hasSuggestionsTarget) return
    
    this.suggestionsTarget.innerHTML = `
      <div style="padding: 24px; text-align: center; color: #dc2626;">
        <p style="margin: 0;">Une erreur s'est produite lors de la recherche</p>
        <p style="margin: 8px 0 0; font-size: 0.875rem; color: #6c757d;">
          Veuillez réessayer
        </p>
      </div>
    `
    this.suggestionsTarget.style.display = "block"
  }
  
  // Show loading indicator
  showLoading() {
    if (this.hasLoadingIndicatorTarget) {
      this.loadingIndicatorTarget.style.display = "block"
    }
  }
  
  // Hide loading indicator
  hideLoading() {
    if (this.hasLoadingIndicatorTarget) {
      this.loadingIndicatorTarget.style.display = "none"
    }
  }
  
  // Select an equipment type
  select(type) {
    // Update input and hidden field
    this.inputTarget.value = type.display_name
    
    if (this.hasHiddenFieldTarget) {
      this.hiddenFieldTarget.value = type.id
    }
    
    // Display selected type information
    this.showSelectedInfo(type)
    
    // Hide suggestions
    this.hideSuggestions()
    
    // Trigger change event
    this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }))
    
    // Custom event for parent components
    this.element.dispatchEvent(new CustomEvent('equipment-type-selected', {
      detail: { equipmentType: type },
      bubbles: true
    }))
  }
  
  // Display selected equipment type details
  showSelectedInfo(type) {
    if (!this.hasSelectedInfoTarget) return
    
    const badgeColor = this.getBadgeColor(type.lot_badge_color)
    
    let html = `
      <div style="
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 8px;
        padding: 16px;
        margin-top: 12px;
        border-left: 4px solid ${badgeColor};
      ">
        <div style="display: flex; align-items: start; gap: 12px; margin-bottom: 12px;">
          <div style="
            background: ${badgeColor};
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
          ">
            ${type.technical_lot_trigram}
          </div>
          <div style="flex: 1;">
            <div style="font-weight: 700; color: #2c3e50; font-size: 16px; margin-bottom: 4px;">
              ${type.code} - ${type.name}
            </div>
            <div style="color: #6c757d; font-size: 14px;">
              ${type.technical_lot_name}
            </div>
          </div>
        </div>
    `
    
    // Add details
    const details = []
    if (type.function) details.push(`<strong>Fonction:</strong> ${type.function}`)
    if (type.purchase_subfamily) details.push(`<strong>Sous-famille:</strong> ${type.purchase_subfamily}`)
    if (type.omniclass_number) details.push(`<strong>OmniClass:</strong> ${type.omniclass_number}`)
    
    if (details.length > 0) {
      html += `
        <div style="
          background: white;
          border-radius: 6px;
          padding: 12px;
          font-size: 13px;
          color: #495057;
          line-height: 1.6;
        ">
          ${details.join('<br>')}
        </div>
      `
    }
    
    // Add characteristics if available
    if (type.characteristics && type.characteristics.length > 0) {
      html += `
        <div style="margin-top: 8px; font-size: 12px; color: #6c757d;">
          <strong>Caractéristiques:</strong> ${type.characteristics.join(', ')}
        </div>
      `
    }
    
    html += `</div>`
    
    this.selectedInfoTarget.innerHTML = html
    this.selectedInfoTarget.style.display = "block"
  }
  
  // Hide selected info
  hideSelectedInfo() {
    if (this.hasSelectedInfoTarget) {
      this.selectedInfoTarget.style.display = "none"
    }
  }
  
  // Hide suggestions
  hideSuggestions() {
    if (this.hasSuggestionsTarget) {
      this.suggestionsTarget.style.display = "none"
    }
  }
  
  // Keyboard navigation
  handleKeydown(event) {
    if (!this.hasSuggestionsTarget || this.suggestionsTarget.style.display === "none") {
      return
    }
    
    const items = this.suggestionsTarget.querySelectorAll('.autocomplete-suggestion-item')
    
    switch(event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.selectedIndex = Math.min(this.selectedIndex + 1, items.length - 1)
        this.updateHighlight()
        break
        
      case 'ArrowUp':
        event.preventDefault()
        this.selectedIndex = Math.max(this.selectedIndex - 1, -1)
        this.updateHighlight()
        break
        
      case 'Enter':
        event.preventDefault()
        if (this.selectedIndex >= 0 && this.equipmentTypes[this.selectedIndex]) {
          this.select(this.equipmentTypes[this.selectedIndex])
        }
        break
        
      case 'Escape':
        event.preventDefault()
        this.hideSuggestions()
        break
    }
  }
  
  // Update visual highlight for keyboard navigation
  updateHighlight() {
    if (!this.hasSuggestionsTarget) return
    
    const items = this.suggestionsTarget.querySelectorAll('.autocomplete-suggestion-item')
    items.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.style.backgroundColor = '#f8f9fa'
      } else {
        item.style.backgroundColor = 'white'
      }
    })
    
    // Scroll into view if needed
    if (this.selectedIndex >= 0 && items[this.selectedIndex]) {
      items[this.selectedIndex].scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  }
  
  // Handle clicks outside to close dropdown
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideSuggestions()
    }
  }
  
  // Clear selection
  clear() {
    this.inputTarget.value = ""
    if (this.hasHiddenFieldTarget) {
      this.hiddenFieldTarget.value = ""
    }
    this.hideSuggestions()
    this.hideSelectedInfo()
    this.selectedLot = null
    this.clearFilterSelection()
  }
}
