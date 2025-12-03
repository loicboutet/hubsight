import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-upload"
export default class extends Controller {
  static targets = [
    "input",
    "dropzone",
    "preview",
    "progressBar",
    "progressText",
    "errorMessage",
    "fileName",
    "fileSize",
    "uploadButton"
  ]

  static values = {
    maxSize: { type: Number, default: 10485760 } // 10MB in bytes
  }

  connect() {
    this.uploadInProgress = false
    this.xhr = null
  }

  disconnect() {
    if (this.xhr) {
      this.xhr.abort()
    }
  }

  // Handle file selection via button click
  selectFile(event) {
    event.stopPropagation() // Prevent dropzone click from also firing
    this.inputTarget.click()
  }

  // Handle dropzone click (but not button clicks inside it)
  handleDropzoneClick(event) {
    // If the click target is the button or inside the button, ignore it
    // The button's own click handler will take care of it
    if (event.target.closest('button')) {
      return
    }
    this.inputTarget.click()
  }

  // Handle file selection from input
  handleFileSelect(event) {
    const file = event.target.files[0]
    if (file) {
      this.validateAndPreviewFile(file)
    }
  }

  // Drag and drop handlers
  handleDragEnter(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropzoneTarget.classList.add('drag-over')
  }

  handleDragOver(event) {
    event.preventDefault()
    event.stopPropagation()
  }

  handleDragLeave(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropzoneTarget.classList.remove('drag-over')
  }

  handleDrop(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropzoneTarget.classList.remove('drag-over')

    const files = event.dataTransfer.files
    if (files.length > 0) {
      const file = files[0]
      // Set the file to the hidden input for form submission
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      this.inputTarget.files = dataTransfer.files
      
      this.validateAndPreviewFile(file)
    }
  }

  // Validate and preview the selected file
  validateAndPreviewFile(file) {
    this.clearError()

    // Validate file type
    if (file.type !== 'application/pdf') {
      this.showError('Le fichier doit être au format PDF')
      this.inputTarget.value = ''
      return
    }

    // Validate file size
    if (file.size > this.maxSizeValue) {
      const maxSizeMB = (this.maxSizeValue / 1048576).toFixed(0)
      this.showError(`Le fichier ne doit pas dépasser ${maxSizeMB} Mo`)
      this.inputTarget.value = ''
      return
    }

    // Show preview
    this.showPreview(file)
  }

  // Show file preview with details
  showPreview(file) {
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'block'
      
      // Update file name
      if (this.hasFileNameTarget) {
        this.fileNameTarget.textContent = file.name
      }
      
      // Update file size
      if (this.hasFileSizeTarget) {
        const sizeMB = (file.size / 1048576).toFixed(2)
        this.fileSizeTarget.textContent = `${sizeMB} Mo`
      }
    }
  }

  // Show error message
  showError(message) {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = message
      this.errorMessageTarget.style.display = 'block'
    }
    
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'none'
    }
  }

  // Clear error message
  clearError() {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = ''
      this.errorMessageTarget.style.display = 'none'
    }
  }

  // Upload with progress tracking (for AJAX uploads)
  uploadWithProgress(event) {
    // This method can be used for AJAX uploads with progress tracking
    // For now, we'll use standard form submission
    // But keeping this for future enhancement with AJAX
    
    const file = this.inputTarget.files[0]
    if (!file) return

    const formData = new FormData()
    formData.append('contract[pdf_document]', file)

    this.xhr = new XMLHttpRequest()

    // Progress tracking
    this.xhr.upload.addEventListener('progress', (e) => {
      if (e.lengthComputable) {
        const percentComplete = (e.loaded / e.total) * 100
        this.updateProgress(percentComplete, e.loaded, e.total)
      }
    })

    // Upload complete
    this.xhr.addEventListener('load', () => {
      if (this.xhr.status === 200) {
        this.uploadComplete()
      } else {
        this.showError('Erreur lors du téléchargement')
        this.resetProgress()
      }
    })

    // Upload error
    this.xhr.addEventListener('error', () => {
      this.showError('Erreur de connexion')
      this.resetProgress()
    })

    // Start upload
    this.uploadInProgress = true
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.display = 'block'
    }

    // This would be the AJAX endpoint - for now commented out
    // this.xhr.open('POST', '/contracts/upload_pdf')
    // this.xhr.send(formData)
  }

  // Update progress bar
  updateProgress(percent, loaded, total) {
    if (this.hasProgressBarTarget) {
      const progressFill = this.progressBarTarget.querySelector('.progress-fill')
      if (progressFill) {
        progressFill.style.width = `${percent}%`
      }
    }

    if (this.hasProgressTextTarget) {
      const loadedMB = (loaded / 1048576).toFixed(2)
      const totalMB = (total / 1048576).toFixed(2)
      this.progressTextTarget.textContent = 
        `Téléchargement en cours... ${Math.round(percent)}% (${loadedMB} / ${totalMB} Mo)`
    }
  }

  // Upload complete
  uploadComplete() {
    this.uploadInProgress = false
    this.resetProgress()
    
    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = 'Téléchargement terminé ✓'
      this.progressTextTarget.style.color = 'var(--green-primary)'
    }
  }

  // Reset progress
  resetProgress() {
    this.uploadInProgress = false
    
    if (this.hasProgressBarTarget) {
      const progressFill = this.progressBarTarget.querySelector('.progress-fill')
      if (progressFill) {
        progressFill.style.width = '0%'
      }
    }

    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = ''
    }
  }

  // Remove/clear the selected file
  removeFile() {
    this.inputTarget.value = ''
    
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'none'
    }
    
    this.clearError()
    this.resetProgress()
  }
}
