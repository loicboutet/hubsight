import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "hiddenField",
    "subfamilyField",
    "suggestions",
    "filterButtons",
    "selectedInfo",
    "loadingIndicator"
  ]
  
  static values = {
    url: { type: String, default: "/api/contract_families/autocomplete" }
  }
  
  connect() {
    console.log("Contract Family Autocomplete controller connected")
    this.selectedFamily = null
    this.debounceTimeout = null
    this.selectedIndex = -1
    this.contractFamilies = []
    
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
      if (this.selectedFamily) {
        params.append('family', this.selectedFamily)
      }
      
      // Fetch data from API
      const response = await fetch(`${this.urlValue}?${params}`)
      if (!response.ok) throw new Error('API request failed')
      
      const data = await response.json()
      this.contractFamilies = data
      
      // Hide loading
      this.hideLoading()
      
      // Display results
      if (data.length > 0) {
        this.showSuggestions(data)
      } else {
        this.showNoResults()
      }
    } catch (error) {
      console.error('Error fetching contract families:', error)
      this.hideLoading()
      this.showError()
    }
  }
  
  // Filter by parent family
  filterByFamily(event) {
    event.preventDefault()
    const button = event.currentTarget
    const family = button.dataset.family
    
    // Toggle selection
    if (this.selectedFamily === family) {
      this.selectedFamily = null
      this.clearFilterSelection()
    } else {
      this.selectedFamily = family
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
      const color = this.getFamilyColor(this.selectedFamily)
      selectedButton.style.backgroundColor = color
      selectedButton.style.color = 'white'
      selectedButton.style.borderColor = color
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
  showSuggestions(families) {
    if (!this.hasSuggestionsTarget) return
    
    this.suggestionsTarget.innerHTML = ""
    
    families.forEach((family, index) => {
      const item = this.createSuggestionItem(family, index)
      this.suggestionsTarget.appendChild(item)
    })
    
    this.suggestionsTarget.style.display = "block"
  }
  
  // Create a single suggestion item
  createSuggestionItem(family, index) {
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
    const badgeColor = this.getFamilyColor(family.family_badge_color)
    
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
          min-width: 50px;
          text-align: center;
        ">
          ${family.code.split('-')[0]}
        </div>
        <div style="flex: 1;">
          <div style="font-weight: 600; color: #2c3e50; margin-bottom: 2px;">
            ${family.code} - ${family.name}
          </div>
          ${this.buildHierarchy(family)}
        </div>
      </div>
    `
    
    // Event listeners
    item.addEventListener("mouseenter", () => {
      this.selectedIndex = index
      this.updateHighlight()
    })
    item.addEventListener("click", () => this.select(family))
    
    return item
  }
  
  // Build hierarchy display
  buildHierarchy(family) {
    if (family.is_family) {
      return `<div style="color: #6c757d; font-size: 0.875rem; margin-top: 2px;">
        Famille principale (${family.code})
      </div>`
    } else {
      return `<div style="color: #6c757d; font-size: 0.875rem; margin-top: 2px;">
        ${family.hierarchy_path}
      </div>`
    }
  }
  
  // Get color for family badge
  getFamilyColor(colorName) {
    const colors = {
      blue: '#3b82f6',
      green: '#10b981',
      yellow: '#f59e0b',
      purple: '#a855f7',
      red: '#ef4444',
      indigo: '#6366f1',
      gray: '#6b7280',
      slate: '#64748b'
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
        <p style="margin: 0 0 8px; font-weight: 600;">Aucune famille de contrat trouvée</p>
        <p style="margin: 0; font-size: 0.875rem;">
          ${this.selectedFamily ? 'Essayez avec une autre famille ou ' : ''}
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
  
  // Select a contract family
  select(family) {
    // Update input with display name
    this.inputTarget.value = family.display_name
    
    // Update hidden field with code
    if (this.hasHiddenFieldTarget) {
      this.hiddenFieldTarget.value = family.code
    }
    
    // Update subfamily field if it's a subfamily
    if (this.hasSubfamilyFieldTarget && family.is_subfamily) {
      this.subfamilyFieldTarget.value = family.name
    }
    
    // Display selected family information
    this.showSelectedInfo(family)
    
    // Hide suggestions
    this.hideSuggestions()
    
    // Trigger change event
    this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }))
    
    // Custom event for parent components
    this.element.dispatchEvent(new CustomEvent('contract-family-selected', {
      detail: { contractFamily: family },
      bubbles: true
    }))
  }
  
  // Display selected contract family details
  showSelectedInfo(family) {
    if (!this.hasSelectedInfoTarget) return
    
    const badgeColor = this.getFamilyColor(family.family_badge_color)
    
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
            ${family.code.split('-')[0]}
          </div>
          <div style="flex: 1;">
            <div style="font-weight: 700; color: #2c3e50; font-size: 16px; margin-bottom: 4px;">
              ${family.code} - ${family.name}
            </div>
            <div style="color: #6c757d; font-size: 14px;">
              ${family.hierarchy_path}
            </div>
          </div>
        </div>
    `
    
    // Add description if available
    if (family.description) {
      html += `
        <div style="
          background: white;
          border-radius: 6px;
          padding: 12px;
          font-size: 13px;
          color: #495057;
          line-height: 1.6;
        ">
          <strong>Description:</strong> ${family.description}
        </div>
      `
    }
    
    // Add family type info
    const typeLabel = family.is_family ? 'Famille principale' : 'Sous-famille'
    html += `
      <div style="margin-top: 8px; font-size: 12px; color: #6c757d;">
        <strong>Type:</strong> ${typeLabel}
      </div>
    `
    
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
        if (this.selectedIndex >= 0 && this.contractFamilies[this.selectedIndex]) {
          this.select(this.contractFamilies[this.selectedIndex])
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
    if (this.hasSubfamilyFieldTarget) {
      this.subfamilyFieldTarget.value = ""
    }
    this.hideSuggestions()
    this.hideSelectedInfo()
    this.selectedFamily = null
    this.clearFilterSelection()
  }
}
