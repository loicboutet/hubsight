import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contract-validation"
export default class extends Controller {
  static targets = ["useAiButton", "finalField"]
  
  connect() {
    console.log("Contract validation controller connected")
  }

  useAiValue(event) {
    event.preventDefault()
    
    const button = event.currentTarget
    const field = button.dataset.field
    const value = button.dataset.value
    const contractId = button.dataset.contractId
    
    // Find the corresponding final value field
    const finalField = document.querySelector(`[data-field="${field}"].final-value-field`)
    
    if (!finalField) {
      console.error(`Could not find final field for: ${field}`)
      return
    }
    
    // Update the input field
    finalField.value = value
    
    // Disable button and show loading state
    button.disabled = true
    const originalText = button.innerHTML
    button.innerHTML = '⏳ Sauvegarde...'
    
    // Prepare data to send
    const formData = new FormData()
    formData.append('field', field)
    formData.append('value', value)
    
    // Get CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    
    // Send AJAX request to save immediately
    fetch(`/contracts/${contractId}/apply_ai_value`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Highlight the field temporarily
        finalField.style.background = '#d4edda'
        setTimeout(() => {
          finalField.style.background = ''
        }, 1000)
        
        // Update button to success state
        button.innerHTML = '✓ Appliqué'
        button.style.background = '#6c757d'
        
        // Show success message
        console.log(`✓ ${field} sauvegardé avec succès`)
      } else {
        // Show error
        alert('Erreur: ' + (data.error || 'Impossible de sauvegarder'))
        button.disabled = false
        button.innerHTML = originalText
      }
    })
    .catch(error => {
      console.error('Erreur AJAX:', error)
      alert('Erreur de connexion. Veuillez réessayer.')
      button.disabled = false
      button.innerHTML = originalText
    })
  }
}
