import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equipment-location"
export default class extends Controller {
  static targets = ["site", "building", "level", "space"]
  static values = {
    hierarchy: Object,
    selectedSite: String,
    selectedBuilding: String,
    selectedLevel: String,
    selectedSpace: String
  }

  connect() {
    // Initialize dropdowns
    if (this.hasHierarchyValue) {
      this.populateSites()
      this.initializeDropdowns()
    }
  }

  populateSites() {
    if (!this.hasHierarchyValue || !this.hasSiteTarget) return

    const sites = this.hierarchyValue.sites
    
    sites.forEach(site => {
      const option = new Option(site.name, site.id)
      if (this.hasSelectedSiteValue && site.id == this.selectedSiteValue) {
        option.selected = true
      }
      this.siteTarget.add(option)
    })
  }

  initializeDropdowns() {
    // For edit form, pre-populate cascading dropdowns
    if (this.hasSelectedSiteValue && this.selectedSiteValue) {
      this.populateBuildingOptions(this.selectedSiteValue)
      
      if (this.hasSelectedBuildingValue && this.selectedBuildingValue) {
        this.populateLevelOptions(this.selectedBuildingValue)
        
        if (this.hasSelectedLevelValue && this.selectedLevelValue) {
          this.populateSpaceOptions(this.selectedLevelValue)
        }
      }
    }
  }

  siteChanged(event) {
    const siteId = event.target.value
    
    // Reset dependent dropdowns
    this.resetDropdown(this.buildingTarget)
    this.resetDropdown(this.levelTarget)
    this.resetDropdown(this.spaceTarget)

    if (siteId) {
      this.populateBuildingOptions(siteId)
    }
  }

  buildingChanged(event) {
    const buildingId = event.target.value
    
    // Reset dependent dropdowns
    this.resetDropdown(this.levelTarget)
    this.resetDropdown(this.spaceTarget)

    if (buildingId) {
      this.populateLevelOptions(buildingId)
    }
  }

  levelChanged(event) {
    const levelId = event.target.value
    
    // Reset dependent dropdown
    this.resetDropdown(this.spaceTarget)

    if (levelId) {
      this.populateSpaceOptions(levelId)
    }
  }

  resetDropdown(dropdown) {
    // Clear all options except the first placeholder
    dropdown.innerHTML = '<option value="">Sélectionner...</option>'
    dropdown.disabled = true
  }

  populateBuildingOptions(siteId) {
    if (!this.hasHierarchyValue) return

    const buildings = this.hierarchyValue.buildings.filter(b => b.site_id == siteId)
    
    this.buildingTarget.innerHTML = '<option value="">Sélectionner un bâtiment...</option>'
    buildings.forEach(building => {
      const option = new Option(building.name, building.id)
      if (this.hasSelectedBuildingValue && building.id == this.selectedBuildingValue) {
        option.selected = true
      }
      this.buildingTarget.add(option)
    })
    this.buildingTarget.disabled = buildings.length === 0
  }

  populateLevelOptions(buildingId) {
    if (!this.hasHierarchyValue) return

    const levels = this.hierarchyValue.levels.filter(l => l.building_id == buildingId)
    
    this.levelTarget.innerHTML = '<option value="">Sélectionner un niveau...</option>'
    levels.forEach(level => {
      const option = new Option(level.name, level.id)
      if (this.hasSelectedLevelValue && level.id == this.selectedLevelValue) {
        option.selected = true
      }
      this.levelTarget.add(option)
    })
    this.levelTarget.disabled = levels.length === 0
  }

  populateSpaceOptions(levelId) {
    if (!this.hasHierarchyValue) return

    const spaces = this.hierarchyValue.spaces.filter(s => s.level_id == levelId)
    
    this.spaceTarget.innerHTML = '<option value="">Sélectionner un espace...</option>'
    spaces.forEach(space => {
      const option = new Option(space.name, space.id)
      if (this.hasSelectedSpaceValue && space.id == this.selectedSpaceValue) {
        option.selected = true
      }
      this.spaceTarget.add(option)
    })
    this.spaceTarget.disabled = spaces.length === 0
  }
}
