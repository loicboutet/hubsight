import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tree"
export default class extends Controller {
  static targets = ["node", "children", "icon"]

  connect() {
    // Load saved state from sessionStorage
    this.loadState()
  }

  toggle(event) {
    event.stopPropagation()
    
    const header = event.currentTarget
    const node = header.closest('[data-tree-target="node"]')
    
    if (!node) return
    
    const children = node.querySelector('[data-tree-target="children"]')
    const icon = header.querySelector('[data-tree-target="icon"]')
    
    if (!children) return
    
    const isExpanded = children.style.display !== 'none'
    
    if (isExpanded) {
      // Collapse
      children.style.display = 'none'
      if (icon) {
        icon.style.transform = 'rotate(0deg)'
      }
    } else {
      // Expand
      children.style.display = 'block'
      if (icon) {
        icon.style.transform = 'rotate(90deg)'
      }
    }
    
    // Save state
    this.saveState()
  }

  expandAll() {
    this.childrenTargets.forEach(children => {
      children.style.display = 'block'
    })
    this.iconTargets.forEach(icon => {
      icon.style.transform = 'rotate(90deg)'
    })
    this.saveState()
  }

  collapseAll() {
    this.childrenTargets.forEach(children => {
      children.style.display = 'none'
    })
    this.iconTargets.forEach(icon => {
      icon.style.transform = 'rotate(0deg)'
    })
    this.saveState()
  }

  saveState() {
    const state = {}
    this.nodeTargets.forEach((node, index) => {
      const children = node.querySelector('[data-tree-target="children"]')
      if (children) {
        state[index] = children.style.display !== 'none'
      }
    })
    sessionStorage.setItem('treeState', JSON.stringify(state))
  }

  loadState() {
    const savedState = sessionStorage.getItem('treeState')
    if (!savedState) return

    try {
      const state = JSON.parse(savedState)
      this.nodeTargets.forEach((node, index) => {
        if (state[index] !== undefined) {
          const children = node.querySelector('[data-tree-target="children"]')
          const icon = node.querySelector('[data-tree-target="icon"]')
          
          if (children) {
            if (state[index]) {
              children.style.display = 'block'
              if (icon) icon.style.transform = 'rotate(90deg)'
            } else {
              children.style.display = 'none'
              if (icon) icon.style.transform = 'rotate(0deg)'
            }
          }
        }
      })
    } catch (e) {
      console.error('Error loading tree state:', e)
    }
  }
}
