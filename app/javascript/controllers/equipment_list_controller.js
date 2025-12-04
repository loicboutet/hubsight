import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filterForm", "table"]

  clearFilters(event) {
    event.preventDefault()
    
    if (!this.hasFilterFormTarget) return
    
    // Clear all form inputs
    const form = this.filterFormTarget
    const inputs = form.querySelectorAll('input[type="text"], input[type="date"], input[type="number"]')
    inputs.forEach(input => input.value = '')
    
    // Reset all select dropdowns to first option (empty value)
    const selects = form.querySelectorAll('select')
    selects.forEach(select => select.selectedIndex = 0)
    
    // Submit the form to reload with no filters
    form.submit()
  }

  sort(event) {
    event.preventDefault()
    
    const column = event.currentTarget.dataset.column
    const currentDirection = event.currentTarget.dataset.direction || 'asc'
    const newDirection = currentDirection === 'asc' ? 'desc' : 'asc'
    
    // Build URL with sort parameters
    const url = new URL(window.location.href)
    url.searchParams.set('sort', column)
    url.searchParams.set('direction', newDirection)
    
    // Navigate to the sorted URL
    window.location.href = url.toString()
  }
}
