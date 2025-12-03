import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contract-dates-calculator"
// Automatically calculates contract dates based on inputs
export default class extends Controller {
  static targets = [
    "executionStartDate",
    "initialDurationMonths", 
    "renewalDurationMonths",
    "renewalCount",
    "noticePeriodDays",
    "endDate",
    "lastRenewalDate",
    "nextDeadlineDate"
  ]
  
  static values = { debounceDelay: { type: Number, default: 300 } }

  connect() {
    console.log("Contract Dates Calculator controller connected")
    this.debounceTimer = null
    
    // Calculate on initial load if we have values
    this.calculateAllDates()
  }

  disconnect() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  // Called when any input field changes
  recalculate() {
    this.debounce(() => {
      this.calculateAllDates()
    })
  }

  // Main calculation function
  calculateAllDates() {
    this.calculateEndDate()
    this.calculateLastRenewalDate()
    this.calculateTerminationDeadline()
  }

  // Calculate the contract end date
  // Formula: Start Date + Initial Duration + (Renewal Count × Renewal Duration)
  calculateEndDate() {
    const startDate = this.getDateValue(this.executionStartDateTarget)
    const initialMonths = this.getNumberValue(this.initialDurationMonthsTarget)

    if (!startDate || !initialMonths) {
      this.endDateTarget.value = ''
      return
    }

    const renewalCount = this.getNumberValue(this.renewalCountTarget) || 0
    const renewalMonths = this.getNumberValue(this.renewalDurationMonthsTarget) || 0

    const totalMonths = initialMonths + (renewalCount * renewalMonths)
    const endDate = this.addMonths(startDate, totalMonths)
    
    this.endDateTarget.value = this.formatDate(endDate)
    this.highlightCalculatedField(this.endDateTarget)
  }

  // Calculate the last renewal date
  // Formula: Start Date + Initial Duration + ((Renewal Count - 1) × Renewal Duration)
  calculateLastRenewalDate() {
    const startDate = this.getDateValue(this.executionStartDateTarget)
    const initialMonths = this.getNumberValue(this.initialDurationMonthsTarget)
    const renewalCount = this.getNumberValue(this.renewalCountTarget) || 0
    const renewalMonths = this.getNumberValue(this.renewalDurationMonthsTarget) || 0

    // Only calculate if we have renewals
    if (!startDate || !initialMonths || renewalCount === 0 || renewalMonths === 0) {
      this.lastRenewalDateTarget.value = ''
      return
    }

    const monthsUntilLastRenewal = initialMonths + ((renewalCount - 1) * renewalMonths)
    const lastRenewalDate = this.addMonths(startDate, monthsUntilLastRenewal)
    
    this.lastRenewalDateTarget.value = this.formatDate(lastRenewalDate)
    this.highlightCalculatedField(this.lastRenewalDateTarget)
  }

  // Calculate the termination deadline
  // Formula: End Date - Notice Period Days
  calculateTerminationDeadline() {
    const endDateStr = this.endDateTarget.value
    const noticePeriodDays = this.getNumberValue(this.noticePeriodDaysTarget)

    if (!endDateStr || !noticePeriodDays) {
      this.nextDeadlineDateTarget.value = ''
      return
    }

    const endDate = new Date(endDateStr)
    if (isNaN(endDate.getTime())) {
      this.nextDeadlineDateTarget.value = ''
      return
    }

    const deadlineDate = this.subtractDays(endDate, noticePeriodDays)
    
    this.nextDeadlineDateTarget.value = this.formatDate(deadlineDate)
    this.highlightCalculatedField(this.nextDeadlineDateTarget)
  }

  // Helper: Get date value from input
  getDateValue(input) {
    const value = input.value
    if (!value) return null
    
    const date = new Date(value)
    return isNaN(date.getTime()) ? null : date
  }

  // Helper: Get number value from input
  getNumberValue(input) {
    const value = parseFloat(input.value)
    return isNaN(value) || value < 0 ? null : value
  }

  // Helper: Add months to a date
  addMonths(date, months) {
    const result = new Date(date)
    result.setMonth(result.getMonth() + months)
    return result
  }

  // Helper: Subtract days from a date
  subtractDays(date, days) {
    const result = new Date(date)
    result.setDate(result.getDate() - days)
    return result
  }

  // Helper: Format date to YYYY-MM-DD for input[type="date"]
  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  // Visual feedback: briefly highlight calculated field
  highlightCalculatedField(element) {
    element.style.transition = 'background-color 0.3s ease'
    element.style.backgroundColor = '#e8f5e9' // Light green
    
    setTimeout(() => {
      element.style.backgroundColor = '#f3f4f6' // Back to gray
    }, 600)
  }

  // Debounce helper to avoid excessive calculations while typing
  debounce(callback) {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
    
    this.debounceTimer = setTimeout(() => {
      callback()
      this.debounceTimer = null
    }, this.debounceDelayValue)
  }
}
