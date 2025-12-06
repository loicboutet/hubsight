// Tasks 38-39: Organization Autocomplete with Real API
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hiddenField", "nameField", "suggestions", "detailsPanel", "contactSelect", "aliases", "similarNames", "similarList"]
  
  connect() {
    console.log("Organization autocomplete controller connected")
    this.debounceTimer = null
  }

  search(event) {
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideSuggestions()
      this.hideDetailsPanel()
      return
    }

    // Debounce API calls (300ms delay)
    clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    try {
      this.showLoading()
      
      const response = await fetch(`/organizations/autocomplete?query=${encodeURIComponent(query)}`)
      
      if (!response.ok) {
        throw new Error('API request failed')
      }
      
      const data = await response.json()
      
      if (data.organizations && data.organizations.length > 0) {
        this.showSuggestions(data.organizations)
      } else {
        this.showNoResults()
      }
    } catch (error) {
      console.error('Organization search error:', error)
      this.showError()
    }
  }

  showLoading() {
    if (!this.hasSuggestionsTarget) return
    
    this.suggestionsTarget.innerHTML = `
      <div style="padding: 16px; text-align: center; color: #6c757d;">
        <div class="spinner-border spinner-border-sm" role="status" style="margin-right: 8px;">
          <span class="visually-hidden">Chargement...</span>
        </div>
        Recherche en cours...
      </div>
    `
    this.suggestionsTarget.style.display = "block"
  }

  showSuggestions(organizations) {
    if (!this.hasSuggestionsTarget) return

    this.suggestionsTarget.innerHTML = ""
    this.suggestionsTarget.style.display = "block"

    organizations.forEach(org => {
      const item = document.createElement("div")
      item.style.cssText = "padding: 12px 16px; cursor: pointer; border-bottom: 1px solid #e9ecef; transition: background-color 0.2s;"
      item.onmouseenter = () => item.style.backgroundColor = "#f8f9fa"
      item.onmouseleave = () => item.style.backgroundColor = "white"
      
      const legalName = org.legal_name ? `<span style="color: #6c757d; font-size: 0.875rem; display: block; margin-top: 2px;">${org.legal_name}</span>` : ''
      const typeLabel = org.type_label ? `<span style="display: inline-block; background: #667eea; color: white; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; margin-top: 4px;">${org.type_label}</span>` : ''
      const specialties = org.specialties ? `<span style="color: #6c757d; font-size: 0.875rem; display: block; margin-top: 2px;">🔧 ${org.specialties}</span>` : ''
      
      item.innerHTML = `
        <div style="font-weight: 500;">${org.name}</div>
        ${legalName}
        ${specialties}
        ${typeLabel}
      `
      
      item.addEventListener("click", () => this.select(org))
      this.suggestionsTarget.appendChild(item)
    })
  }

  showNoResults() {
    if (!this.hasSuggestionsTarget) return

    this.suggestionsTarget.innerHTML = `
      <div style="padding: 16px; text-align: center; color: #6c757d;">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="margin: 0 auto 8px; opacity: 0.5;">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p style="margin: 0;">Aucune organisation trouvée</p>
        <p style="margin: 8px 0 0; font-size: 0.875rem;">Vérifiez l'orthographe ou créez une nouvelle organisation</p>
      </div>
    `
    this.suggestionsTarget.style.display = "block"
  }

  showSimilarNames(organizations) {
    if (!this.hasSimilarNamesTarget || !this.hasSimilarListTarget) return

    this.similarListTarget.innerHTML = ""
    
    organizations.forEach(org => {
      const li = document.createElement("li")
      li.style.cssText = "cursor: pointer; color: #856404; padding: 4px 0; text-decoration: underline;"
      li.textContent = org.matchedAlias || org.matchedFormerName || org.name
      li.addEventListener("click", () => this.select(org))
      this.similarListTarget.appendChild(li)
    })

    this.similarNamesTarget.style.display = "block"
  }

  hideSimilarNames() {
    if (this.hasSimilarNamesTarget) {
      this.similarNamesTarget.style.display = "none"
    }
  }

  select(organization) {
    this.inputTarget.value = organization.name
    
    if (this.hasHiddenFieldTarget) {
      this.hiddenFieldTarget.value = organization.id
    }
    
    // Also set the name field for form submission
    if (this.hasNameFieldTarget) {
      this.nameFieldTarget.value = organization.name
    }

    // Display aliases if available
    if (this.hasAliasesTarget && organization.aliases && organization.aliases.length > 0) {
      this.aliasesTarget.textContent = `Également connu sous: ${organization.aliases.join(", ")}`
      this.aliasesTarget.style.display = "block"
    }

    this.hideSuggestions()
    this.hideSimilarNames()

    // Trigger change event for any listeners
    this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }))
  }

  showError() {
    if (!this.hasSuggestionsTarget) return

    this.suggestionsTarget.innerHTML = `
      <div style="padding: 16px; text-align: center; color: #dc3545;">
        <p style="margin: 0;">❌ Erreur lors de la recherche</p>
        <p style="margin: 8px 0 0; font-size: 0.875rem;">Veuillez réessayer</p>
      </div>
    `
    this.suggestionsTarget.style.display = "block"
  }

  hideSuggestions() {
    if (this.hasSuggestionsTarget) {
      this.suggestionsTarget.style.display = "none"
    }
  }
  
  hideDetailsPanel() {
    if (this.hasDetailsPanelTarget) {
      this.detailsPanelTarget.style.display = "none"
    }
  }
  
  showDetailsPanel(organization) {
    if (!this.hasDetailsPanelTarget) return
    
    // Build details panel HTML
    let contactsHTML = ''
    if (organization.contacts && organization.contacts.length > 0) {
      contactsHTML = `
        <div style="margin-top: 12px;">
          <strong>Contacts:</strong>
          <ul style="margin: 8px 0; padding-left: 20px;">
            ${organization.contacts.map(c => `
              <li>${c.display_name}${c.phone ? ` - ${c.phone}` : ''}</li>
            `).join('')}
          </ul>
        </div>
      `
    }
    
    let agenciesHTML = ''
    if (organization.agencies && organization.agencies.length > 0) {
      agenciesHTML = `
        <div style="margin-top: 12px;">
          <strong>Agences:</strong>
          <ul style="margin: 8px 0; padding-left: 20px;">
            ${organization.agencies.map(a => `
              <li>${a.name}${a.city ? ` (${a.city})` : ''}</li>
            `).join('')}
          </ul>
        </div>
      `
    }
    
    this.detailsPanelTarget.innerHTML = `
      <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 16px; border-radius: 8px; margin-top: 12px;">
        <h4 style="margin: 0 0 12px 0;">${organization.name}</h4>
        ${organization.legal_name ? `<p style="margin: 4px 0;"><strong>Raison sociale:</strong> ${organization.legal_name}</p>` : ''}
        ${organization.formatted_siret ? `<p style="margin: 4px 0;"><strong>SIRET:</strong> ${organization.formatted_siret}</p>` : ''}
        ${organization.phone ? `<p style="margin: 4px 0;"><strong>Téléphone:</strong> ${organization.phone}</p>` : ''}
        ${organization.email ? `<p style="margin: 4px 0;"><strong>Email:</strong> ${organization.email}</p>` : ''}
        ${organization.specialties ? `<p style="margin: 4px 0;"><strong>Spécialités:</strong> ${organization.specialties}</p>` : ''}
        ${contactsHTML}
        ${agenciesHTML}
      </div>
    `
    this.detailsPanelTarget.style.display = "block"
  }

  // Close suggestions when clicking outside
  disconnect() {
    clearTimeout(this.debounceTimer)
  }
}
