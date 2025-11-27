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

    // Handle login input validation
    document.querySelectorAll('.deletion-login-input').forEach(input => {
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
      // Focus on the login input
      const loginInput = modal.querySelector('.deletion-login-input')
      if (loginInput) {
        setTimeout(() => loginInput.focus(), 100)
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
      const loginInput = modal.querySelector('.deletion-login-input')
      if (loginInput) {
        loginInput.value = ''
      }
      const checkbox = modal.querySelector('.cascade-delete-checkbox')
      if (checkbox) {
        checkbox.checked = false
      }
      const errorMessage = modal.querySelector('.login-error-message')
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

    const loginInput = modal.querySelector('.deletion-login-input')
    const checkbox = modal.querySelector('.cascade-delete-checkbox')
    const confirmBtn = modal.querySelector('.confirm-delete-btn')
    const errorMessage = modal.querySelector('.login-error-message')

    // Check if login is filled
    const loginValue = loginInput ? loginInput.value.trim() : ''
    const isLoginValid = loginValue.length > 0

    // Check if checkbox is required and checked
    let isCheckboxValid = true
    if (checkbox) {
      isCheckboxValid = checkbox.checked
    }

    // Additional client-side validation for email/username format
    const isFormatValid = this.validateLoginFormat(loginValue)

    // Show/hide error message
    if (errorMessage) {
      if (loginValue.length > 0 && !isFormatValid) {
        errorMessage.textContent = 'Format invalide. Veuillez saisir un email ou nom d\'utilisateur valide.'
        errorMessage.style.display = 'block'
      } else if (loginValue.length === 0 && loginInput === document.activeElement) {
        errorMessage.textContent = 'Veuillez saisir votre identifiant'
        errorMessage.style.display = 'none' // Don't show until they blur or try to submit
      } else {
        errorMessage.style.display = 'none'
      }
    }

    // Enable/disable confirm button
    const isValid = isLoginValid && isCheckboxValid && isFormatValid
    if (confirmBtn) {
      confirmBtn.disabled = !isValid
      confirmBtn.style.opacity = isValid ? '1' : '0.5'
      confirmBtn.style.cursor = isValid ? 'pointer' : 'not-allowed'
    }
  }

  validateLoginFormat(value) {
    if (!value || value.length === 0) return false
    
    // Basic validation: either email format or alphanumeric username
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    const usernameRegex = /^[a-zA-Z0-9_.-]{3,}$/
    
    return emailRegex.test(value) || usernameRegex.test(value)
  }

  handleDelete(modalId, button) {
    const modal = document.getElementById(modalId)
    if (!modal) return

    const loginInput = modal.querySelector('.deletion-login-input')
    const errorMessage = modal.querySelector('.login-error-message')
    const entityType = button.getAttribute('data-entity-type')
    const entityName = button.getAttribute('data-entity-name')
    const deletePath = button.getAttribute('data-delete-path')

    // Final validation
    const loginValue = loginInput ? loginInput.value.trim() : ''
    if (!loginValue || !this.validateLoginFormat(loginValue)) {
      if (errorMessage) {
        errorMessage.textContent = 'Veuillez saisir un identifiant valide pour continuer'
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

    // Simulate deletion (frontend demo)
    // In production, this would make an actual DELETE request to deletePath
    setTimeout(() => {
      // Show success message
      this.showSuccessMessage(entityType, entityName)
      
      // Close modal
      this.closeModal(modalId)
      
      // Reset button state
      button.disabled = false
      button.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
        </svg>
        Confirmer la suppression
      `

      // Note: Actual deletion would be implemented here with Rails UJS or Fetch API
      // Example:
      // fetch(deletePath, {
      //   method: 'DELETE',
      //   headers: {
      //     'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      //     'Content-Type': 'application/json'
      //   },
      //   body: JSON.stringify({ login: loginValue })
      // })
      // .then(response => response.json())
      // .then(data => {
      //   if (data.success) {
      //     this.showSuccessMessage(entityType, entityName)
      //     this.closeModal(modalId)
      //     // Refresh page or remove element from DOM
      //     window.location.reload()
      //   } else {
      //     this.showErrorMessage(data.error)
      //   }
      // })
    }, 1500)
  }

  showSuccessMessage(entityType, entityName) {
    // Create a toast notification
    const toast = document.createElement('div')
    toast.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background-color: #eff6ff;
      border-left: 4px solid #3b82f6;
      padding: 16px 20px;
      border-radius: 8px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
      z-index: 10000;
      max-width: 400px;
      animation: slideIn 0.3s ease-out;
    `
    toast.innerHTML = `
      <div style="display: flex; align-items: start; gap: 12px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="#3b82f6" stroke-width="2" style="flex-shrink: 0; margin-top: 2px;">
          <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <div>
          <p style="margin: 0 0 4px 0; font-weight: 600; color: #1e40af; font-size: 0.938rem;">
            Implémentation frontend terminée
          </p>
          <p style="margin: 0; color: #1e40af; font-size: 0.813rem;">
            L'interface de suppression pour <strong>${entityName}</strong> est prête. La suppression réelle nécessite l'implémentation backend.
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
