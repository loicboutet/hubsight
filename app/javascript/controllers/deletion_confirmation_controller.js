import { Controller } from "@hotwired/stimulus"

// Deletion Confirmation Controller - Items 28-33
// Handles modal interactions for deletion confirmation
export default class extends Controller {
  connect() {
    this.setupEventListeners()
  }

  setupEventListeners() {
    // Handle delete button clicks (opens modal)
    document.querySelectorAll('[data-action="open-delete-modal"]').forEach(button => {
      button.addEventListener('click', (e) => {
        e.preventDefault()
        const modalId = button.getAttribute('data-modal-id')
        this.openModal(modalId)
      })
    })

    // Handle close modal buttons
    document.querySelectorAll('.close-modal-btn').forEach(button => {
      button.addEventListener('click', (e) => {
        e.preventDefault()
        const modalId = button.getAttribute('data-modal-id')
        this.closeModal(modalId)
      })
    })

    // Handle password input validation
    document.querySelectorAll('.deletion-password-input').forEach(input => {
      input.addEventListener('input', (e) => {
        const modalId = input.getAttribute('data-modal-id')
        this.validateForm(modalId)
      })
    })

    // Handle cascade delete checkbox
    document.querySelectorAll('.cascade-delete-checkbox').forEach(checkbox => {
      checkbox.addEventListener('change', (e) => {
        const modalId = checkbox.getAttribute('data-modal-id')
        this.validateForm(modalId)
      })
    })

    // Handle confirm delete buttons
    document.querySelectorAll('.confirm-delete-btn').forEach(button => {
      button.addEventListener('click', (e) => {
        e.preventDefault()
        const modalId = button.getAttribute('data-modal-id')
        this.handleDelete(modalId, button)
      })
    })

    // Handle clicks outside modal to close
    document.querySelectorAll('.deletion-modal').forEach(modal => {
      modal.addEventListener('click', (e) => {
        if (e.target === modal) {
          const modalId = modal.id
          this.closeModal(modalId)
        }
      })
    })

    // Handle ESC key to close modal
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        const openModal = document.querySelector('.deletion-modal[style*="display: flex"]')
        if (openModal) {
          this.closeModal(openModal.id)
        }
      }
    })
  }

  openModal(modalId) {
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.style.display = 'flex'
      // Focus on the password input
      const passwordInput = modal.querySelector('.deletion-password-input')
      if (passwordInput) {
        setTimeout(() => passwordInput.focus(), 100)
      }
      // Prevent body scroll
      document.body.style.overflow = 'hidden'
    }
  }

  closeModal(modalId) {
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.style.display = 'none'
      // Reset form
      const passwordInput = modal.querySelector('.deletion-password-input')
      if (passwordInput) {
        passwordInput.value = ''
      }
      const checkbox = modal.querySelector('.cascade-delete-checkbox')
      if (checkbox) {
        checkbox.checked = false
      }
      const errorMessage = modal.querySelector('.password-error-message')
      if (errorMessage) {
        errorMessage.style.display = 'none'
      }
      const confirmBtn = modal.querySelector('.confirm-delete-btn')
      if (confirmBtn) {
        confirmBtn.disabled = true
        confirmBtn.style.opacity = '0.5'
        confirmBtn.style.cursor = 'not-allowed'
      }
      // Re-enable body scroll
      document.body.style.overflow = ''
    }
  }

  validateForm(modalId) {
    const modal = document.getElementById(modalId)
    if (!modal) return

    const passwordInput = modal.querySelector('.deletion-password-input')
    const checkbox = modal.querySelector('.cascade-delete-checkbox')
    const confirmBtn = modal.querySelector('.confirm-delete-btn')
    const errorMessage = modal.querySelector('.password-error-message')

    // Check if password is filled
    const passwordValue = passwordInput ? passwordInput.value.trim() : ''
    const isPasswordValid = passwordValue.length > 0

    // Check if checkbox is required and checked
    let isCheckboxValid = true
    if (checkbox) {
      isCheckboxValid = checkbox.checked
    }

    // Show/hide error message
    if (errorMessage) {
      if (passwordValue.length === 0 && passwordInput === document.activeElement) {
        errorMessage.style.display = 'none' // Don't show until they blur or try to submit
      } else {
        errorMessage.style.display = 'none'
      }
    }

    // Enable/disable confirm button
    const isValid = isPasswordValid && isCheckboxValid
    if (confirmBtn) {
      confirmBtn.disabled = !isValid
      confirmBtn.style.opacity = isValid ? '1' : '0.5'
      confirmBtn.style.cursor = isValid ? 'pointer' : 'not-allowed'
    }
  }

  handleDelete(modalId, button) {
    const modal = document.getElementById(modalId)
    if (!modal) return

    const passwordInput = modal.querySelector('.deletion-password-input')
    const errorMessage = modal.querySelector('.password-error-message')
    const entityType = button.getAttribute('data-entity-type')
    const entityName = button.getAttribute('data-entity-name')
    const deletePath = button.getAttribute('data-delete-path')

    // Final validation
    const passwordValue = passwordInput ? passwordInput.value.trim() : ''
    if (!passwordValue) {
      if (errorMessage) {
        errorMessage.textContent = 'Veuillez saisir votre mot de passe pour continuer'
        errorMessage.style.display = 'block'
      }
      return
    }

    // Check cascade checkbox if required
    const checkbox = modal.querySelector('.cascade-delete-checkbox')
    if (checkbox && !checkbox.checked) {
      alert('Vous devez confirmer avoir compris les conséquences de cette suppression.')
      return
    }

    // Show loading state
    button.disabled = true
    button.innerHTML = `
      <svg class="animate-spin" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
      </svg>
      Suppression en cours...
    `

    // Get CSRF token
    const csrfToken = document.querySelector('[name="csrf-token"]')?.content

    // Make DELETE request to backend
    fetch(deletePath, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ password: passwordValue })
    })
    .then(response => {
      // Check if response is redirect (Rails redirects on success)
      if (response.redirected) {
        window.location.href = response.url
        return null
      }
      
      // Try to parse JSON for error handling
      return response.text().then(text => {
        try {
          return JSON.parse(text)
        } catch {
          // Not JSON, likely HTML redirect
          if (response.ok) {
            window.location.reload()
            return null
          }
          throw new Error('Erreur lors de la suppression')
        }
      })
    })
    .then(data => {
      if (data === null) return // Already handled redirect
      
      if (data.success) {
        this.showSuccessMessage(entityType, entityName)
        this.closeModal(modalId)
        // Reload page after short delay
        setTimeout(() => window.location.reload(), 1000)
      } else {
        this.showErrorMessage(data.error || 'Une erreur est survenue lors de la suppression')
        this.resetButton(button)
      }
    })
    .catch(error => {
      console.error('Delete error:', error)
      this.showErrorMessage(error.message || 'Une erreur est survenue lors de la suppression')
      this.resetButton(button)
    })
  }

  resetButton(button) {
    button.disabled = false
    button.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
      </svg>
      Confirmer la suppression
    `
  }

  showSuccessMessage(entityType, entityName) {
    // Create a toast notification
    const toast = document.createElement('div')
    toast.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background-color: #d1fae5;
      border-left: 4px solid #10b981;
      padding: 16px 20px;
      border-radius: 8px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
      z-index: 10000;
      max-width: 400px;
      animation: slideIn 0.3s ease-out;
    `
    toast.innerHTML = `
      <div style="display: flex; align-items: start; gap: 12px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="#10b981" stroke-width="2" style="flex-shrink: 0; margin-top: 2px;">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <div>
          <p style="margin: 0 0 4px 0; font-weight: 600; color: #065f46; font-size: 0.938rem;">
            Suppression réussie
          </p>
          <p style="margin: 0; color: #065f46; font-size: 0.813rem;">
            ${entityType} <strong>${entityName}</strong> a été supprimé avec succès. Cette action a été enregistrée dans l'audit trail.
          </p>
        </div>
      </div>
    `

    // Add animation
    const style = document.createElement('style')
    style.textContent = `
      @keyframes slideIn {
        from {
          transform: translateX(100%);
          opacity: 0;
        }
        to {
          transform: translateX(0);
          opacity: 1;
        }
      }
    `
    document.head.appendChild(style)

    document.body.appendChild(toast)

    // Auto-remove after 5 seconds
    setTimeout(() => {
      toast.style.animation = 'slideIn 0.3s ease-out reverse'
      setTimeout(() => {
        toast.remove()
        style.remove()
      }, 300)
    }, 5000)
  }

  showErrorMessage(error) {
    alert(`Erreur: ${error}`)
  }
}
