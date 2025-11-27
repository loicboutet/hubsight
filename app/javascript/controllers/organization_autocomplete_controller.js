// Items 22-23: Organization Autocomplete with Fuzzy Matching
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hiddenField", "suggestions", "similarNames", "similarList", "aliases"]
  
  connect() {
    console.log("Organization autocomplete controller connected")
    
    // Sample organizations data - in production this would come from an API
    this.organizations = [
      { id: 1, name: "ENGIE Solutions", aliases: ["ENGIE SA", "ENGIE Services", "Groupe ENGIE"], former_names: ["GDF Suez"] },
      { id: 2, name: "ENGIE SA", aliases: ["ENGIE Solutions", "ENGIE Services"], former_names: [] },
      { id: 3, name: "Bouygues Energies & Services", aliases: ["Bouygues E&S"], former_names: ["ETDE"] },
      { id: 4, name: "Veolia", aliases: ["Veolia Environnement"], former_names: ["Vivendi Environnement"] },
      { id: 5, name: "Sodexo", aliases: ["Sodexo Facilities Management"], former_names: [] },
      { id: 6, name: "SPIE Facilities", aliases: ["SPIE", "SPIE Batignolles"], former_names: [] },
      { id: 7, name: "Elior Services", aliases: ["Elior Group"], former_names: [] },
      { id: 8, name: "Dalkia", aliases: ["Dalkia France"], former_names: [] },
      { id: 9, name: "Cofely", aliases: ["Cofely Services"], former_names: [] },
      { id: 10, name: "Eiffage Energie Systèmes", aliases: ["Eiffage Energie", "Clemessy"], former_names: [] }
    ]
  }

  search(event) {
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideSuggestions()
      this.hideSimilarNames()
      return
    }

    // Perform fuzzy matching
    const matches = this.fuzzySearch(query)
    
    if (matches.exact.length > 0) {
      this.showSuggestions(matches.exact)
      this.hideSimilarNames()
    } else if (matches.similar.length > 0) {
      this.showSuggestions(matches.similar.slice(0, 5))
      this.showSimilarNames(matches.similar.slice(0, 3))
    } else {
      this.showNoResults()
    }
  }

  fuzzySearch(query) {
    const lowerQuery = query.toLowerCase()
    const exact = []
    const similar = []

    this.organizations.forEach(org => {
      const lowerName = org.name.toLowerCase()
      
      // Exact match or starts with
      if (lowerName.includes(lowerQuery)) {
        exact.push(org)
      } 
      // Check aliases
      else if (org.aliases.some(alias => alias.toLowerCase().includes(lowerQuery))) {
        similar.push({ ...org, matchedAlias: org.aliases.find(a => a.toLowerCase().includes(lowerQuery)) })
      }
      // Check former names
      else if (org.former_names.some(fn => fn.toLowerCase().includes(lowerQuery))) {
        similar.push({ ...org, matchedFormerName: org.former_names.find(fn => fn.toLowerCase().includes(lowerQuery)) })
      }
      // Fuzzy matching based on similarity
      else if (this.calculateSimilarity(lowerName, lowerQuery) > 0.6) {
        similar.push(org)
      }
    })

    return { exact, similar }
  }

  calculateSimilarity(str1, str2) {
    // Simple Levenshtein distance-based similarity
    const longer = str1.length > str2.length ? str1 : str2
    const shorter = str1.length > str2.length ? str2 : str1
    
    if (longer.length === 0) return 1.0
    
    const editDistance = this.levenshteinDistance(longer, shorter)
    return (longer.length - editDistance) / longer.length
  }

  levenshteinDistance(str1, str2) {
    const matrix = []

    for (let i = 0; i <= str2.length; i++) {
      matrix[i] = [i]
    }

    for (let j = 0; j <= str1.length; j++) {
      matrix[0][j] = j
    }

    for (let i = 1; i <= str2.length; i++) {
      for (let j = 1; j <= str1.length; j++) {
        if (str2.charAt(i - 1) === str1.charAt(j - 1)) {
          matrix[i][j] = matrix[i - 1][j - 1]
        } else {
          matrix[i][j] = Math.min(
            matrix[i - 1][j - 1] + 1,
            matrix[i][j - 1] + 1,
            matrix[i - 1][j] + 1
          )
        }
      }
    }

    return matrix[str2.length][str1.length]
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
      
      let displayName = org.name
      let subtitle = ""
      
      if (org.matchedAlias) {
        subtitle = `<span style="color: #6c757d; font-size: 0.875rem; display: block; margin-top: 2px;">Aussi connu sous: ${org.matchedAlias}</span>`
      } else if (org.matchedFormerName) {
        subtitle = `<span style="color: #6c757d; font-size: 0.875rem; display: block; margin-top: 2px;">Ancien nom: ${org.matchedFormerName}</span>`
      } else if (org.aliases && org.aliases.length > 0) {
        subtitle = `<span style="color: #6c757d; font-size: 0.875rem; display: block; margin-top: 2px;">Aliases: ${org.aliases.join(", ")}</span>`
      }
      
      item.innerHTML = `
        <div style="font-weight: 500;">${displayName}</div>
        ${subtitle}
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

    // Display aliases if available
    if (this.hasAliasesTarget && organization.aliases.length > 0) {
      this.aliasesTarget.textContent = `Également connu sous: ${organization.aliases.join(", ")}`
      this.aliasesTarget.style.display = "block"
    }

    this.hideSuggestions()
    this.hideSimilarNames()

    // Trigger change event for any listeners
    this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }))
  }

  hideSuggestions() {
    if (this.hasSuggestionsTarget) {
      this.suggestionsTarget.style.display = "none"
    }
  }

  // Close suggestions when clicking outside
  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }
}
