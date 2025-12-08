# 💻 ASUS Laptop - Quick Wins & Backend Tasks
**Assigned Work**: Phase 2 Quick Backend Implementations
**Total Time**: 8-11 hours
**Focus**: Backend logic, validation, UI messaging

---

## ✅ Progress Tracker

- [ ] Task 1: Savings Module Lock Backend (1-2 hours)
- [ ] Task 2: Association Validation (2-3 hours)
- [ ] Task 3: Home Page Messaging (2-3 hours)
- [ ] Task 4: Deletion Modal - Contracts (2-3 hours)

**Total Progress**: 0/4 tasks (0%)

---

## 📋 TASK 1: Savings Module Lock Backend (Items 34-36)
**Time**: 1-2 hours | **Priority**: HIGH | **Status**: ❌ TODO

### What's Already Done ✅
- UI is 100% complete in both dashboard and savings pages
- Progress bars, locked/unlocked states, beautiful design all ready

### What You Need to Do

#### Step 1: Update Dashboard Controller (15 minutes)
**File**: `app/controllers/dashboard_controller.rb`

Add after line with `@total_contracts = contracts.count`:

```ruby
# ASUS Task 1: Savings Module Lock
@contracts_count = @total_contracts
@savings_unlocked = (@contracts_count >= 5)
@contracts_needed = [5 - @contracts_count, 0].max
@progress_percentage = (@contracts_count * 100.0 / 5).clamp(0, 100).round
```

#### Step 2: Update Savings Controller (15 minutes)
**File**: `app/controllers/savings_controller.rb`

Add at the top of the class:
```ruby
before_action :check_savings_unlocked

private

def check_savings_unlocked
  # Get contracts count based on user role
  contracts = if current_user.admin?
    Contract.all
  else
    Contract.by_organization(current_user.organization_id)
  end
  
  @contracts_count = contracts.count
  @savings_unlocked = (@contracts_count >= 5)
  @contracts_needed = [5 - @contracts_count, 0].max
  
  # Redirect to dashboard if not unlocked
  unless @savings_unlocked
    redirect_to dashboard_path, 
                alert: "Le module Économies se déverrouille automatiquement après avoir importé 5 contrats. Il vous en manque #{@contracts_needed}."
  end
end
```

#### Step 3: Update Dashboard View (10 minutes)
**File**: `app/views/dashboard/index.html.erb`

Find these lines (around line 180-183):
```ruby
contracts_count = 2  # Replace with: @contracts_count
savings_unlocked = false  # Replace with: @savings_unlocked
contracts_needed = 3  # Replace with: @contracts_needed
```

Replace with:
```ruby
contracts_count = @contracts_count
savings_unlocked = @savings_unlocked
contracts_needed = @contracts_needed
```

#### Step 4: Update Savings View (10 minutes)
**File**: `app/views/savings/index.html.erb`

Find similar placeholder lines and replace with:
```ruby
contracts_count = @contracts_count
savings_unlocked = @savings_unlocked
contracts_needed = @contracts_needed
```

#### Step 5: Test (20 minutes)
1. Visit `/dashboard` - Should see real contract count
2. If count < 5: Should see locked card with correct progress
3. If count >= 5: Should see unlocked card
4. Visit `/savings` with < 5 contracts - Should redirect with message
5. Visit `/savings` with >= 5 contracts - Should show page

### ✅ Done Criteria
- [ ] Real contract counts display correctly
- [ ] Progress bar shows accurate percentage
- [ ] Savings page redirects when locked
- [ ] Unlock happens automatically at 5 contracts

---

## 📋 TASK 2: Association Validation (Items 24-25)
**Time**: 2-3 hours | **Priority**: HIGH | **Status**: ❌ TODO

### What's Already Done ✅
- Organization autocomplete in contract forms
- Hidden fields for organization_id and organization_name

### What You Need to Do

#### Step 1: Add Backend Validation to Contracts Controller (45 minutes)
**File**: `app/controllers/contracts_controller.rb`

Add this private method at the bottom:

```ruby
# ASUS Task 2: Validate contractor organization
def validate_contractor_organization
  # Skip if no contractor organization specified
  return if params[:contract][:contractor_organization_id].blank?
  
  org_id = params[:contract][:contractor_organization_id]
  org_name = params[:contract][:contractor_organization_name]
  
  # Verify organization exists
  organization = Organization.find_by(id: org_id)
  
  unless organization
    flash[:alert] = "Organisation invalide. Veuillez sélectionner une organisation existante."
    return false
  end
  
  # Verify name matches (allow slight variations due to autocomplete)
  unless organization.name.downcase.include?(org_name.downcase) || 
         org_name.downcase.include?(organization.name.downcase)
    flash[:alert] = "Le nom de l'organisation ne correspond pas à la sélection."
    return false
  end
  
  true
end
```

Add before_action:
```ruby
before_action :validate_contractor_organization, only: [:create, :update]
```

#### Step 2: Add Model Validation (30 minutes)
**File**: `app/models/contract.rb`

Add custom validation:

```ruby
# ASUS Task 2: Prevent free text contractor entries
validate :contractor_organization_must_be_valid, if: :contractor_organization_id?

private

def contractor_organization_must_be_valid
  return unless contractor_organization_id.present?
  
  organization = Organization.find_by(id: contractor_organization_id)
  
  if organization.nil?
    errors.add(:contractor_organization_id, "doit référencer une organisation existante")
  elsif contractor_organization_name.present? && 
        !organization.name.downcase.include?(contractor_organization_name.downcase)
    errors.add(:contractor_organization_name, "ne correspond pas à l'organisation sélectionnée")
  end
end
```

#### Step 3: Update Strong Parameters (15 minutes)
**File**: `app/controllers/contracts_controller.rb`

In `contract_params` method, ensure these are permitted:
```ruby
:contractor_organization_id,
:contractor_organization_name,
```

#### Step 4: Add Frontend Validation (45 minutes)
**File**: `app/javascript/controllers/organization_autocomplete_controller.js`

Update to require selection (prevent free text):

```javascript
// On form submit, validate organization was selected
connect() {
  this.element.closest('form')?.addEventListener('submit', (e) => {
    const nameField = this.nameFieldTarget
    const hiddenField = this.hiddenFieldTarget
    
    // If name is filled but no ID selected, prevent submit
    if (nameField.value && !hiddenField.value) {
      e.preventDefault()
      alert('Veuillez sélectionner une organisation dans la liste')
      nameField.focus()
    }
  })
}
```

#### Step 5: Test (30 minutes)
1. Try creating contract with valid organization - Should work
2. Try typing free text without selection - Should prevent submit
3. Try submitting with mismatched name/ID - Should show error
4. Try editing with invalid org_id - Should show error
5. Test with empty contractor field - Should allow (optional field)

### ✅ Done Criteria
- [ ] Cannot submit free text (not in Organization table)
- [ ] Error messages clear and user-friendly
- [ ] Valid organizations still work perfectly
- [ ] Optional field - can leave blank

---

## 📋 TASK 3: Home Page Messaging (Item 37)
**Time**: 2-3 hours | **Priority**: MEDIUM | **Status**: ❌ TODO

### What You Need to Do

#### Step 1: Create Beautiful Home Page (2 hours)
**File**: `app/views/home/index.html.erb`

Replace entire content with:

```erb
<div style="min-height: 100vh; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; padding: 40px 20px;">
  <div style="max-width: 1200px; width: 100%; text-align: center;">
    
    <!-- Logo & Title -->
    <div style="margin-bottom: 60px;">
      <h1 style="font-size: 4rem; font-weight: 800; color: white; margin: 0 0 20px 0; text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
        HubSight
      </h1>
      <div style="display: inline-block; padding: 8px 20px; background-color: #48bb78; color: white; border-radius: 50px; font-weight: 600; font-size: 0.875rem; margin-bottom: 30px;">
        ✨ 100% Plateforme Gratuite
      </div>
      
      <!-- Tagline -->
      <p style="font-size: 1.5rem; color: rgba(255,255,255,0.95); max-width: 700px; margin: 0 auto; line-height: 1.6;">
        Gérez vos contrats. Ne manquez jamais une échéance. Analysez vos économies potentielles.
      </p>
    </div>

    <!-- Features Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 30px; margin-bottom: 60px;">
      
      <!-- Feature 1 -->
      <div style="background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 40px 30px; border: 1px solid rgba(255,255,255,0.2);">
        <div style="width: 60px; height: 60px; background: rgba(255,255,255,0.2); border-radius: 15px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" viewBox="0 0 24 24" stroke="white" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 style="color: white; font-size: 1.25rem; font-weight: 600; margin-bottom: 15px;">Gestion de Contrats</h3>
        <p style="color: rgba(255,255,255,0.8); font-size: 0.938rem; line-height: 1.6;">
          Centralisez tous vos contrats et suivez automatiquement les échéances importantes
        </p>
      </div>

      <!-- Feature 2 -->
      <div style="background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 40px 30px; border: 1px solid rgba(255,255,255,0.2);">
        <div style="width: 60px; height: 60px; background: rgba(255,255,255,0.2); border-radius: 15px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" viewBox="0 0 24 24" stroke="white" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
          </svg>
        </div>
        <h3 style="color: white; font-size: 1.25rem; font-weight: 600; margin-bottom: 15px;">Alertes Intelligentes</h3>
        <p style="color: rgba(255,255,255,0.8); font-size: 0.938rem; line-height: 1.6;">
          Recevez des notifications avant chaque échéance pour ne rien manquer
        </p>
      </div>

      <!-- Feature 3 -->
      <div style="background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 40px 30px; border: 1px solid rgba(255,255,255,0.2);">
        <div style="width: 60px; height: 60px; background: rgba(255,255,255,0.2); border-radius: 15px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" viewBox="0 0 24 24" stroke="white" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 style="color: white; font-size: 1.25rem; font-weight: 600; margin-bottom: 15px;">Analyse d'Économies</h3>
        <p style="color: rgba(255,255,255,0.8); font-size: 0.938rem; line-height: 1.6;">
          Identifiez automatiquement les opportunités d'économies sur vos contrats
        </p>
      </div>
    </div>

    <!-- Unlock Message -->
    <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(10px); border-radius: 20px; padding: 30px; border: 1px solid rgba(255,255,255,0.3); margin-bottom: 40px; max-width: 800px; margin-left: auto; margin-right: auto;">
      <div style="display: flex; align-items: center; gap: 15px; justify-content: center;">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="white" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M8 11V7a4 4 0 118 0m-4 8v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2z" />
        </svg>
        <p style="color: white; font-size: 1.125rem; margin: 0; font-weight: 500;">
          🎁 Le module <strong>Économies Potentielles</strong> se déverrouille automatiquement dès que vous importez 5 contrats
        </p>
      </div>
    </div>

    <!-- CTA Buttons -->
    <div style="display: flex; gap: 20px; justify-content: center; flex-wrap: wrap;">
      <% if user_signed_in? %>
        <%= link_to dashboard_path, style: "display: inline-flex; align-items: center; gap: 10px; padding: 18px 40px; background-color: white; color: #667eea; border-radius: 12px; font-weight: 700; font-size: 1.125rem; text-decoration: none; box-shadow: 0 10px 40px rgba(0,0,0,0.2); transition: transform 0.2s;" do %>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          Accéder au Tableau de Bord
        <% end %>
      <% else %>
        <%= link_to new_user_session_path, style: "display: inline-flex; align-items: center; gap: 10px; padding: 18px 40px; background-color: white; color: #667eea; border-radius: 12px; font-weight: 700; font-size: 1.125rem; text-decoration: none; box-shadow: 0 10px 40px rgba(0,0,0,0.2); transition: transform 0.2s;" do %>
          Se Connecter
        <% end %>
        <%= link_to new_user_registration_path, style: "display: inline-flex; align-items: center; gap: 10px; padding: 18px 40px; background-color: rgba(255,255,255,0.2); color: white; border: 2px solid white; border-radius: 12px; font-weight: 700; font-size: 1.125rem; text-decoration: none; transition: all 0.2s;" do %>
          Créer un Compte
        <% end %>
      <% end %>
    </div>

    <!-- Footer Note -->
    <p style="color: rgba(255,255,255,0.7); font-size: 0.875rem; margin-top: 60px;">
      HubSight © 2025 - Gestion intelligente de vos contrats
    </p>
  </div>
</div>

<style>
  a[href="<%= dashboard_path %>"]{ transition: transform 0.2s;}
  a[href="<%= dashboard_path %>"]:hover {
    transform: translateY(-2px);
    box-shadow: 0 15px 50px rgba(0,0,0,0.3);
  }
</style>
```

#### Step 2: Test (30 minutes)
1. Visit root URL `/` - Should see beautiful landing page
2. Check all 3 features display
3. Check unlock message visible
4. Test CTA buttons work
5. Test both logged-in and logged-out states

### ✅ Done Criteria
- [ ] Beautiful gradient background
- [ ] All 3 features displayed with icons
- [ ] Unlock message about 5 contracts
- [ ] CTA buttons work correctly
- [ ] Responsive on mobile

---

## 📋 TASK 4: Deletion Modal - Contracts (Item 28)
**Time**: 2-3 hours | **Priority**: HIGH | **Status**: ❌ TODO

### What's Already Done ✅
- Deletion modal component exists
- Working on Equipment, Sites, Buildings

### What You Need to Do

#### Step 1: Add Modal to Contracts Index (1 hour)
**File**: `app/views/contracts/index.html.erb`

Find the delete button in the actions column (around line with "Éditer"):

Replace:
```erb
<%= link_to contract_path(contract), method: :delete, 
    data: { turbo_confirm: "Are you sure?" } do %>
  Delete
<% end %>
```

With:
```erb
<button type="button"
  data-action="click->deletion-confirmation#openModal"
  data-modal-id="deletion-modal-contract-<%= contract.id %>"
  style="display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background-color: #dc2626; color: white; border: none; border-radius: 4px; font-size: 0.75rem; font-weight: 600; cursor: pointer; text-decoration: none;">
  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
    <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
  </svg>
  Supprimer
</button>
```

#### Step 2: Add Modal Component (30 minutes)

After the table, before pagination, add:

```erb
<!-- Deletion Modals for Each Contract -->
<% @contracts.each do |contract| %>
  <%= render 'shared/deletion_confirmation_modal',
    entity_type: 'le contrat',
    entity_name: "#{contract.contract_number} - #{contract.title}",
    entity_id: "contract-#{contract.id}",
    affected_items: {
      'équipements liés' => 0,  # TODO: Calculate real count
      'alertes actives' => 0     # TODO: Calculate real count
    },
    requires_extra_confirmation: false,
    delete_path: contract_path(contract)
  %>
<% end %>

<!-- Initialize deletion confirmation controller -->
<div data-controller="deletion-confirmation"></div>
```

#### Step 3: Create Deletion JavaScript Controller (45 minutes)
**File**: `app/javascript/controllers/deletion_confirmation_controller.js`

Create if doesn't exist:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openModal(event) {
    const modalId = event.currentTarget.dataset.modalId
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.style.display = 'flex'
      
      // Focus password input
      const passwordInput = modal.querySelector('.deletion-password-input')
      if (passwordInput) {
        setTimeout(() => passwordInput.focus(), 100)
      }
      
      // Setup password validation
      this.setupPasswordValidation(modal)
      
      // Setup close buttons
      this.setupCloseButtons(modal)
      
      // Setup confirm button
      this.setupConfirmButton(modal)
    }
  }
  
  setupPasswordValidation(modal) {
    const passwordInput = modal.querySelector('.deletion-password-input')
    const confirmBtn = modal.querySelector('.confirm-delete-btn')
    const checkbox = modal.querySelector('.cascade-delete-checkbox')
    
    const updateButtonState = () => {
      const hasPassword = passwordInput && passwordInput.value.length > 0
      const checkboxValid = !checkbox || checkbox.checked
      
      if (confirmBtn) {
        confirmBtn.disabled = !(hasPassword && checkboxValid)
        confirmBtn.style.opacity = (hasPassword && checkboxValid) ? '1' : '0.5'
        confirmBtn.style.cursor = (hasPassword && checkboxValid) ? 'pointer' : 'not-allowed'
      }
    }
    
    if (passwordInput) {
      passwordInput.addEventListener('input', updateButtonState)
    }
    if (checkbox) {
      checkbox.addEventListener('change', updateButtonState)
    }
  }
  
  setupCloseButtons(modal) {
    const closeButtons = modal.querySelectorAll('.close-modal-btn')
    closeButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        modal.style.display = 'none'
        // Reset form
        const passwordInput = modal.querySelector('.deletion-password-input')
        if (passwordInput) passwordInput.value = ''
        const checkbox = modal.querySelector('.cascade-delete-checkbox')
        if (checkbox) checkbox.checked = false
      })
    })
  }
  
  setupConfirmButton(modal) {
    const confirmBtn = modal.querySelector('.confirm-delete-btn')
    const passwordInput = modal.querySelector('.deletion-password-input')
    
    if (confirmBtn) {
      confirmBtn.addEventListener('click', async () => {
        const deletePath = confirmBtn.dataset.deletePath
        const password = passwordInput ? passwordInput.value : ''
        
        // TODO: Verify password with backend before deletion
        if (confirm('Confirmer la suppression définitive ?')) {
          // Create form and submit
          const form = document.createElement('form')
          form.method = 'POST'
          form.action = deletePath
          
          const methodInput = document.createElement('input')
          methodInput.type = 'hidden'
          methodInput.name = '_method'
          methodInput.value = 'delete'
          
          const tokenInput = document.createElement('input')
          tokenInput.type = 'hidden'
          tokenInput.name = 'authenticity_token'
          tokenInput.value = document.querySelector('meta[name="csrf-token"]').content
          
          const passwordField = document.createElement('input')
          passwordField.type = 'hidden'
          passwordField.name = 'deletion_password'
          passwordField.value = password
          
          form.appendChild(methodInput)
          form.appendChild(tokenInput)
          form.appendChild(passwordField)
          document.body.appendChild(form)
          form.submit()
        }
      })
    }
  }
}
```

#### Step 4: Test (30 minutes)
1. Go to contracts list
2. Click "Supprimer" on a contract
3. Modal should open
4. Try submitting without password - Should be disabled
5. Enter password - Button should enable
6. Click confirm - Should delete contract

### ✅ Done Criteria
- [ ] Modal opens when clicking delete
- [ ] Password required to enable submit
- [ ] Close button works
- [ ] Delete executes successfully
- [ ] Modal looks beautiful

---

## 🎯 Summary for ASUS

**Total Tasks**: 4
**Total Time**: 8-11 hours
**Focus Areas**: Backend logic, validation, UI components

**Order of Execution** (Recommended):
1. Task 1: Savings Lock (easiest, 1-2 hours)
2. Task 3: Home Page (visual progress, 2-3 hours)
3. Task 2: Association Validation (moderate, 2-3 hours)
4. Task 4: Deletion Modal (requires most attention, 2-3 hours)

**Git Strategy**:
- Create branch: `git checkout -b asus/quick-wins`
- Commit after each task
- Push regularly to avoid conflicts with HP laptop

**Communication with HP**:
- Let HP person know when you finish each task
- HP is working on different files, so conflicts should be minimal
- Coordinate before merging to main branch

---

## ✅ Final Checklist

After completing all tasks:

- [ ] All 4 tasks completed and tested
- [ ] Code committed to git
- [ ] Pushed to remote repository
- [ ] Coordinated with HP laptop work
- [ ] Ready to merge changes

**Last Updated**: December 8, 2025 5:40 PM
**Next Review**: After HP tasks complete
