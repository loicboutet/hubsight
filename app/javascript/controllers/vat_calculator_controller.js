import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vat-calculator"
export default class extends Controller {
  static targets = ["vatRate", "amountHt", "amountTtc", "monthlyAmount"]
  static values = { debounceDelay: { type: Number, default: 300 } }

  connect() {
    console.log("VAT Calculator controller connected")
    this.debounceTimer = null
    
    // Set default VAT rate if empty
    if (!this.vatRateTarget.value || this.vatRateTarget.value === '') {
      this.vatRateTarget.value = '20.00'
    }
  }

  disconnect() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  // Called when VAT rate changes
  calculate() {
    this.debounce(() => {
      // If both HT and TTC exist, recalculate TTC from HT when rate changes
      if (this.amountHtTarget.value) {
        this.calculateTtcFromHt()
      } else if (this.amountTtcTarget.value) {
        this.calculateHtFromTtc()
      }
    })
  }

  // Called when HT amount changes
  calculateFromHt() {
    this.debounce(() => {
      this.calculateTtcFromHt()
    })
  }

  // Called when TTC amount changes
  calculateFromTtc() {
    this.debounce(() => {
      this.calculateHtFromTtc()
    })
  }

  // Calculate TTC (inclusive) from HT (exclusive)
  calculateTtcFromHt() {
    const ht = parseFloat(this.amountHtTarget.value)
    const vatRate = parseFloat(this.vatRateTarget.value)

    if (isNaN(ht) || isNaN(vatRate) || ht < 0 || vatRate < 0) {
      return
    }

    const ttc = ht * (1 + vatRate / 100)
    this.amountTtcTarget.value = this.formatAmount(ttc)
    
    this.calculateMonthly()
    this.highlightCalculatedField(this.amountTtcTarget)
  }

  // Calculate HT (exclusive) from TTC (inclusive)
  calculateHtFromTtc() {
    const ttc = parseFloat(this.amountTtcTarget.value)
    const vatRate = parseFloat(this.vatRateTarget.value)

    if (isNaN(ttc) || isNaN(vatRate) || ttc < 0 || vatRate < 0) {
      return
    }

    const ht = ttc / (1 + vatRate / 100)
    this.amountHtTarget.value = this.formatAmount(ht)
    
    this.calculateMonthly()
    this.highlightCalculatedField(this.amountHtTarget)
  }

  // Calculate monthly from annual TTC
  calculateMonthly() {
    const ttc = parseFloat(this.amountTtcTarget.value)

    if (isNaN(ttc) || ttc < 0) {
      this.monthlyAmountTarget.value = ''
      return
    }

    const monthly = ttc / 12
    this.monthlyAmountTarget.value = this.formatAmount(monthly)
    this.highlightCalculatedField(this.monthlyAmountTarget)
  }

  // Format amount to 2 decimal places
  formatAmount(amount) {
    return amount.toFixed(2)
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
