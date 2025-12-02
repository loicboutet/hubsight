import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site-list"
export default class extends Controller {
  static targets = ["filterForm", "searchInput", "typeSelect", "regionSelect", "sortSelect"]

  connect() {
    console.log("Site list controller connected")
  }

  // Apply filters (form submission)
  applyFilters(event) {
    event.preventDefault()
    const form = this.filterFormTarget
    
    // Build URL with filter parameters
    const url = new URL(window.location.origin + window.location.pathname)
    const formData = new FormData(form)
    
    // Add each non-empty parameter to URL
    for (let [key, value] of formData.entries()) {
      if (value && value.trim() !== '') {
        url.searchParams.set(key, value)
      }
    }
    
    // Navigate to filtered URL
    window.location.href = url.toString()
  }

  // Clear all filters
  clearFilters(event) {
    event.preventDefault()
    
    if (this.hasFilterFormTarget) {
      const form = this.filterFormTarget
      
      // Clear all form inputs
      form.querySelectorAll('input[type="text"]').forEach(input => input.value = '')
      form.querySelectorAll('select').forEach(select => select.selectedIndex = 0)
      
      // Reload page without filters
      window.location.href = window.location.pathname
    }
  }

  // Handle sort change
  changeSort(event) {
    const sortBy = event.target.value
    const url = new URL(window.location.href)
    
    if (sortBy && sortBy !== '') {
      url.searchParams.set('sort_by', sortBy)
    } else {
      url.searchParams.delete('sort_by')
    }
    
    // Keep existing filters
    window.location.href = url.toString()
  }
}
