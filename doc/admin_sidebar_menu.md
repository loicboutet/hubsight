# Admin Sidebar Menu Structure

Based on routes.md analysis, this document defines the complete sidebar menu structure for Admin users.

## Menu Categories

### 🏠 DASHBOARD
Main overview and analytics for administrators.

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Dashboard | `/dashboard` | 📊 chart-line | Main admin dashboard with overview |
| Analytics | `/analytics` | 📈 chart-bar | Analytics overview (BRIQUE 2) |

---

### 👥 ADMIN MANAGEMENT
Admin-specific functionality for managing the platform.

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Portfolio Managers | `/admin/portfolio_managers` | 👥 users-cog | Manage portfolio manager users |
| Clients | `/admin/clients` | 🏢 building-user | View and access client portfolios |
| Price References | `/admin/price_references` | 💰 tags | Manage reference pricing data (BRIQUE 2) |

---

### 🏢 PORTFOLIO MANAGEMENT
Full access to all portfolio management features (same as Portfolio Manager role).

#### Sites & Properties
| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Sites | `/sites` | 🏢 building | List and manage all sites |
| Buildings | `/buildings` | 🏗️ building-columns | List and manage all buildings |
| Levels | `/levels` | 📐 layer-group | List and manage all levels |
| Spaces | `/spaces` | 🚪 door-open | List and manage all spaces |

#### Equipment
| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Equipment | `/equipment` | ⚙️ cogs | List and manage all equipment |
| Equipment Types | `/equipment_types` | 🔧 wrench | View equipment type catalog (OmniClass) |

#### Contracts & Organizations
| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Contracts | `/contracts` | 📄 file-contract | List and manage all contracts |
| Organizations | `/organizations` | 🏭 industry | Manage organizations (contractors, suppliers) |
| Contacts | `/contacts` | 👤 address-book | List and manage all contacts |
| Contract Families | `/contract_families` | 📂 folder-tree | View contract families & subfamilies |

---

### 👤 USER MANAGEMENT

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Site Managers | `/site_managers` | 👤 user-shield | Manage site manager users and site assignments |

---

### 🔔 ALERTS & SAVINGS (BRIQUE 2)

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Alerts | `/alerts` | 🔔 bell | Dashboard of all alerts across all portfolios |
| Alert Settings | `/alerts/settings` | ⚙️ sliders | Configure alert preferences |
| Savings Analysis | `/savings` | 💵 piggy-bank | View potential savings overview |

---

### 🔍 SEARCH & UTILITIES

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Global Search | `/search` | 🔍 magnifying-glass | Universal search across all entities |

---

### 📊 DATA MANAGEMENT

| Menu Item | Route | Icon | Description |
|-----------|-------|------|-------------|
| Imports | N/A | 📥 file-import | Submenu for import operations |
| ↳ Import Equipment Types | `/imports/equipment_types` | 🔧 file-arrow-down | Import OmniClass Excel |
| ↳ Import Spaces | `/imports/spaces` | 🚪 file-arrow-down | Import spaces structure Excel |
| ↳ Import Contract Families | `/imports/contract_families` | 📂 file-arrow-down | Import contract families Excel |
| ↳ Import Price References | `/admin/price_references/import` | 💰 file-arrow-down | Import price reference Excel |
| Exports | N/A | 📤 file-export | Submenu for export operations |
| ↳ Export Contracts | `/exports/contracts` | 📄 file-arrow-up | Export contracts to Excel/CSV |
| ↳ Export Equipment | `/exports/equipment` | ⚙️ file-arrow-up | Export equipment to Excel/CSV |
| ↳ Export Sites | `/exports/sites` | 🏢 file-arrow-up | Export site structure to Excel/CSV |
| ↳ Export Price References | `/admin/price_references/export` | 💰 file-arrow-up | Export price references |

---

## Recommended Sidebar Structure (Hierarchical with Icons)

```
📊 Dashboard
   └─ 📊 Overview (/dashboard)
   └─ 📈 Analytics (/analytics)

👥 Administration
   └─ 👥 Portfolio Managers (/admin/portfolio_managers)
   └─ 🏢 Clients (/admin/clients)
   └─ 👤 Site Managers (/site_managers)
   └─ 💰 Price References (/admin/price_references)

🏢 Portfolio
   └─ 🏢 Sites (/sites)
   └─ 🏗️ Buildings (/buildings)
   └─ 📐 Levels (/levels)
   └─ 🚪 Spaces (/spaces)
   └─ ⚙️ Equipment (/equipment)
   └─ 📄 Contracts (/contracts)

🏭 Resources
   └─ 🏭 Organizations (/organizations)
   └─ 👤 Contacts (/contacts)
   └─ 🔧 Equipment Types (/equipment_types)
   └─ 📂 Contract Families (/contract_families)

🔔 Monitoring (BRIQUE 2)
   └─ 🔔 Alerts (/alerts)
   └─ ⚙️ Alert Settings (/alerts/settings)
   └─ 💵 Savings Analysis (/savings)

🔧 Tools
   └─ 🔍 Global Search (/search)
   └─ 📥 Imports
      └─ 🔧 Equipment Types (/imports/equipment_types)
      └─ 🚪 Spaces (/imports/spaces)
      └─ 📂 Contract Families (/imports/contract_families)
      └─ 💰 Price References (/admin/price_references/import)
   └─ 📤 Exports
      └─ 📄 Contracts (/exports/contracts)
      └─ ⚙️ Equipment (/exports/equipment)
      └─ 🏢 Sites (/exports/sites)
      └─ 💰 Price References (/admin/price_references/export)
```

---

## Sidebar Menu Implementation Notes

### Access Control
- **Admin** users have access to ALL menu items
- Menu items should show counts/badges where applicable:
  - Unacknowledged alerts count
  - New contracts pending validation
  - Active site managers

### Visual Hierarchy
- **Primary Navigation** (Main Categories): Bold, larger icons
- **Secondary Navigation** (Sub-items): Regular weight, smaller icons, indented
- **Active State**: Highlight current page/section
- **Collapsible Sections**: Allow users to collapse/expand categories

### Special Features
1. **Client Impersonation**: When impersonating a client, show a prominent banner/indicator
2. **Quick Actions**: Add quick action buttons for common tasks:
   - New Site
   - New Contract
   - Upload Contract
   - New Organization
3. **Search Bar**: Persistent global search at top of sidebar or header
4. **Role Indicator**: Show "Admin" badge to indicate current role

### Responsive Behavior
- **Desktop**: Full expanded sidebar with labels
- **Tablet**: Collapsed sidebar with icons only, expands on hover
- **Mobile**: Hidden sidebar, accessible via hamburger menu

---

## Menu Items by Priority (for minimal/mobile view)

### High Priority (Always Visible)
1. Dashboard
2. Portfolio Managers
3. Clients
4. Sites
5. Contracts
6. Alerts

### Medium Priority (Collapsible)
7. Equipment
8. Organizations
9. Site Managers
10. Price References
11. Analytics

### Low Priority (Hidden in submenu/more)
12. Equipment Types
13. Contract Families
14. Imports
15. Exports
16. Alert Settings
17. Savings Analysis

---

## Complete Icon Reference

### FontAwesome Icon Classes
For implementation, use FontAwesome or similar icon libraries with these suggested classes:

| Menu Item | Icon Emoji | FontAwesome Class | Alternative |
|-----------|------------|-------------------|-------------|
| **Dashboard** | 📊 | `fa-chart-line` | `fa-tachometer-alt` |
| **Analytics** | 📈 | `fa-chart-bar` | `fa-chart-area` |
| **Portfolio Managers** | 👥 | `fa-users-cog` | `fa-user-tie` |
| **Clients** | 🏢 | `fa-building-user` | `fa-briefcase` |
| **Site Managers** | 👤 | `fa-user-shield` | `fa-user-check` |
| **Price References** | 💰 | `fa-tags` | `fa-dollar-sign` |
| **Sites** | 🏢 | `fa-building` | `fa-city` |
| **Buildings** | 🏗️ | `fa-building-columns` | `fa-landmark` |
| **Levels** | 📐 | `fa-layer-group` | `fa-bars-staggered` |
| **Spaces** | 🚪 | `fa-door-open` | `fa-vector-square` |
| **Equipment** | ⚙️ | `fa-cogs` | `fa-tools` |
| **Equipment Types** | 🔧 | `fa-wrench` | `fa-screwdriver-wrench` |
| **Contracts** | 📄 | `fa-file-contract` | `fa-file-signature` |
| **Organizations** | 🏭 | `fa-industry` | `fa-building-flag` |
| **Contacts** | 👤 | `fa-address-book` | `fa-users` |
| **Contract Families** | 📂 | `fa-folder-tree` | `fa-sitemap` |
| **Alerts** | 🔔 | `fa-bell` | `fa-exclamation-triangle` |
| **Alert Settings** | ⚙️ | `fa-sliders` | `fa-cog` |
| **Savings** | 💵 | `fa-piggy-bank` | `fa-hand-holding-dollar` |
| **Global Search** | 🔍 | `fa-magnifying-glass` | `fa-search` |
| **Imports** | 📥 | `fa-file-import` | `fa-download` |
| **Import Items** | 📥 | `fa-file-arrow-down` | `fa-arrow-down-to-line` |
| **Exports** | 📤 | `fa-file-export` | `fa-upload` |
| **Export Items** | 📤 | `fa-file-arrow-up` | `fa-arrow-up-from-line` |

### Icon Color Suggestions

For better visual hierarchy and quick recognition:

| Category | Suggested Color | Hex Code |
|----------|----------------|----------|
| Dashboard | Blue | `#3B82F6` |
| Admin/Management | Purple | `#8B5CF6` |
| Portfolio/Sites | Green | `#10B981` |
| Equipment | Orange | `#F59E0B` |
| Contracts | Indigo | `#6366F1` |
| Organizations | Teal | `#14B8A6` |
| Alerts | Red | `#EF4444` |
| Savings | Emerald | `#059669` |
| Tools | Gray | `#6B7280` |
| Search | Slate | `#475569` |

### Icon Sizes

| Context | Size | Usage |
|---------|------|-------|
| Main menu items | 20px | Primary navigation |
| Sub-menu items | 16px | Secondary navigation |
| Badges/Counters | 14px | Notification counts |
| Mobile menu | 24px | Touch-friendly |
| Collapsed sidebar | 24px | Icon-only view |

---

## Additional Considerations

### Breadcrumb Navigation
In addition to sidebar, implement breadcrumbs for deep navigation:
```
Admin > Clients > Site ABC > Buildings > Building 1 > Levels > Floor 2
```

### Contextual Actions
When viewing a specific resource, show contextual actions in the sidebar or a secondary panel:
- Edit
- Delete
- Export
- Related items
- History/Audit log

### Notifications
- Badge on "Alerts" menu item showing unacknowledged count
- Optional: Badge on "Contracts" showing pending validations
- Toast notifications for background operations (imports, exports)

---

**Last Updated**: January 2025  
**Version**: 1.0  
**Scope**: Admin sidebar menu for BRIQUE 1 & BRIQUE 2
