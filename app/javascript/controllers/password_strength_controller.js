import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "meter", "feedback", "requirement"]

  connect() {
    this.checkStrength()
  }

  checkStrength() {
    const password = this.inputTarget.value
    const strength = this.calculateStrength(password)
    
    this.updateMeter(strength)
    this.updateFeedback(strength, password)
    this.updateRequirements(password)
  }

  calculateStrength(password) {
    let strength = 0
    
    if (password.length >= 8) strength++
    if (password.length >= 12) strength++
    if (/[a-z]/.test(password)) strength++
    if (/[A-Z]/.test(password)) strength++
    if (/[0-9]/.test(password)) strength++
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++
    
    return strength
  }

  updateMeter(strength) {
    if (!this.hasMeterTarget) return
    
    const meterBar = this.meterTarget.querySelector('.strength-bar')
    const meterText = this.meterTarget.querySelector('.strength-text')
    
    if (strength === 0) {
      meterBar.style.width = '0%'
      meterBar.style.backgroundColor = '#e9ecef'
      meterText.textContent = ''
      meterText.style.color = '#6c757d'
    } else if (strength <= 2) {
      meterBar.style.width = '33%'
      meterBar.style.backgroundColor = '#dc2626'
      meterText.textContent = 'Faible'
      meterText.style.color = '#dc2626'
    } else if (strength <= 4) {
      meterBar.style.width = '66%'
      meterBar.style.backgroundColor = '#f59e0b'
      meterText.textContent = 'Moyen'
      meterText.style.color = '#f59e0b'
    } else {
      meterBar.style.width = '100%'
      meterBar.style.backgroundColor = '#10b981'
      meterText.textContent = 'Fort'
      meterText.style.color = '#10b981'
    }
  }

  updateFeedback(strength, password) {
    if (!this.hasFeedbackTarget) return
    
    let message = ''
    
    if (password.length === 0) {
      message = ''
    } else if (strength <= 2) {
      message = '⚠️ Mot de passe trop faible - Respectez toutes les exigences'
    } else if (strength <= 4) {
      message = '⚡ Mot de passe acceptable - Peut être amélioré'
    } else {
      message = '✓ Excellent mot de passe !'
    }
    
    this.feedbackTarget.textContent = message
  }

  updateRequirements(password) {
    if (!this.hasRequirementTarget) return
    
    this.requirementTargets.forEach(requirement => {
      const type = requirement.dataset.requirement
      let isMet = false
      
      switch(type) {
        case 'length':
          isMet = password.length >= 8
          break
        case 'uppercase':
          isMet = /[A-Z]/.test(password)
          break
        case 'lowercase':
          isMet = /[a-z]/.test(password)
          break
        case 'digit':
          isMet = /[0-9]/.test(password)
          break
        case 'special':
          isMet = /[!@#$%^&*]/.test(password)
          break
      }
      
      if (isMet) {
        requirement.classList.remove('requirement-unmet')
        requirement.classList.add('requirement-met')
        requirement.querySelector('.check-icon').innerHTML = '✓'
        requirement.querySelector('.check-icon').style.color = '#10b981'
      } else {
        requirement.classList.remove('requirement-met')
        requirement.classList.add('requirement-unmet')
        requirement.querySelector('.check-icon').innerHTML = '○'
        requirement.querySelector('.check-icon').style.color = '#6c757d'
      }
    })
  }
}
