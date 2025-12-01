import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contract-list"
export default class extends Controller {
  static targets = ["columnCheckbox", "table", "filterForm"]
  static values = {
    updateColumnsUrl: String
  }

  connect() {
    console.log("Contract list controller connected")
    this.loadColumnPreferences()
  }

  // Sort table by column
  sort(event) {
    event.preventDefault()
    const link = event.currentTarget
    const column = link.dataset.column
    const currentDirection = link.dataset.direction || 'asc'
    const newDirection = currentDirection === 'asc' ? 'desc' : 'asc'
    
    // Build URL with sort parameters
    const url = new URL(window.location.href)
    url.searchParams.set('sort', column)
    url.searchParams.set('direction', newDirection)
    
    // Navigate to sorted URL
    window.location.href = url.toString()
  }

  // Toggle column visibility
  toggleColumn(event) {
    const checkbox = event.target
    const columnName = checkbox.value
    const isVisible = checkbox.checked
    
    // Update table columns visibility
    this.updateColumnVisibility(columnName, isVisible)
    
    // Save preferences to backend
    this.saveColumnPreferences()
  }

  // Update column visibility in the DOM
  updateColumnVisibility(columnName, isVisible) {
    const display = isVisible ? '' : 'none'
    
    // Update th elements
    document.querySelectorAll(`th[data-column="${columnName}"]`).forEach(th => {
      th.style.display = display
    })
    
    // Update td elements
    document.querySelectorAll(`td[data-column="${columnName}"]`).forEach(td => {
      td.style.display = display
    })
  }

  // Load column preferences from checkboxes and apply them
  loadColumnPreferences() {
    this.columnCheckboxTargets.forEach(checkbox => {
      const columnName = checkbox.value
      const isVisible = checkbox.checked
      this.updateColumnVisibility(columnName, isVisible)
    })
  }

  // Save column preferences to session via AJAX
  saveColumnPreferences() {
    const visibleColumns = this.columnCheckboxTargets
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value)
    
    // Send AJAX request to save preferences
    fetch(this.updateColumnsUrlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ columns: visibleColumns })
    })
    .then(response => {
      if (response.ok) {
        console.log('Column preferences saved')
      }
    })
    .catch(error => console.error('Error saving column preferences:', error))
  }

  // Apply filters (form submission)
  applyFilters(event) {
    // Let the form submit naturally
    // or prevent and handle via AJAX if needed
  }

  // Clear all filters (updated for Task 34 - includes advanced filters)
  clearFilters(event) {
    event.preventDefault()
    
    if (this.hasFilterFormTarget) {
      // Clear all form inputs
      const form = this.filterFormTarget
      form.querySelectorAll('input[type="text"]').forEach(input => input.value = '')
      form.querySelectorAll('input[type="number"]').forEach(input => input.value = '')
      form.querySelectorAll('input[type="date"]').forEach(input => input.value = '')
      form.querySelectorAll('select').forEach(select => select.value = '')
      
      // Submit form to reload with no filters
      form.submit()
    }
  }

  // Toggle advanced filters panel (NEW - Task 34)
  toggleAdvancedFilters(event) {
    event.preventDefault()
    
    const advancedPanel = document.getElementById('advanced-filters')
    const toggleButton = event.currentTarget
    const icon = toggleButton.querySelector('.advanced-filters-icon')
    const text = toggleButton.querySelector('.advanced-filters-text')
    
    if (advancedPanel) {
      const isHidden = advancedPanel.classList.contains('hidden')
      
      if (isHidden) {
        // Show advanced filters
        advancedPanel.classList.remove('hidden')
        icon.style.transform = 'rotate(180deg)'
        text.textContent = 'Masquer les Filtres Avancés'
      } else {
        // Hide advanced filters
        advancedPanel.classList.add('hidden')
        icon.style.transform = 'rotate(0deg)'
        text.textContent = 'Filtres Avancés (Dates, Montants, etc.)'
      }
    }
  }

  // Change items per page
  changePerPage(event) {
    const perPage = event.target.value
    const url = new URL(window.location.href)
    url.searchParams.set('per_page', perPage)
    url.searchParams.delete('page') // Reset to page 1
    window.location.href = url.toString()
  }

  // Toggle column customization dropdown
  toggleColumnDropdown(event) {
    event.preventDefault()
    const dropdown = document.getElementById('column-customization-dropdown')
    if (dropdown) {
      dropdown.classList.toggle('hidden')
    }
  }
}
