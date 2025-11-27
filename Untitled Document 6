# HubSight Project Analysis - Based on en_specification.md

## Project Overview

HubSight is a **web platform for contractual management and monitoring** focused on real estate and technical property management. It centralizes all maintenance contracts, upkeep agreements, technical/biological controls, subcontracting, supplies, insurance, and real estate documents (property deeds, leases, condominium regulations).

## Core Requirements

The project is divided into **2 modules (Bricks)** with progressive deployment:

### BRICK 1 - Basic Contract Management (€5,000)
**Key Features:**
- **Asset Structure Management**: Hierarchical organization (Portfolio > Sites > Buildings > Equipment)
- **AI-Powered Contract Extraction**: Upload PDF contracts → Mistral OCR extracts text → LLM (OpenRouter) automatically structures data (contract numbers, dates, service providers, amounts, equipment lists)
- **Manual Data Entry & Validation**: Users can validate/correct AI extractions or manually create contracts
- **Database Linking**: Equipment to OmniClass codes, services to contract families, organizations to third parties
- **Visualization**: Contract lists with filters, tree navigation, PDF summary sheets
- **Dashboard**: Portfolio overview with key indicators

### BRICK 2 - Automatic Matching & Price Comparison (€5,000)
**Key Features:**
- **Automated Database Matching**: AI matches extracted equipment/services to databases with confidence scores
- **Alert System**: 
  - "Upcoming" alerts (X days before deadline)
  - "At risk" alerts (deadline passed)
  - "Missing contracts" alerts (mandatory contracts not referenced)
  - Email notifications for critical alerts
- **Price Reference Database**: Compare contractual prices vs. market reference prices
- **Savings Calculation**: Automatic calculation of potential savings (absolute value & percentage)
- **Enhanced Dashboard**: Total savings by site/portfolio, active alerts, expiring contracts (30/60/90 days)
- **Economic Reporting**: Export PDF analysis reports

## How the Site Operates

1. **Data Entry Workflow**:
   - Upload PDF contract → AI extracts & structures data → User validates/corrects → System links to databases

2. **Asset Management**:
   - Hierarchical structure organization using OmniClass classification
   - Import via Excel files (equipment, spaces, contract families)

3. **Contract Monitoring**:
   - Automatic calculation of renewal dates, expiry dates, termination deadlines
   - Alert system triggers notifications before critical deadlines
   - Dashboard provides overview of portfolio health

4. **Economic Analysis**:
   - System compares actual contract prices against reference database
   - Calculates potential savings opportunities
   - Generates reports for decision-making

## Users (3 Profile Types)

### 👤 Admin (5000.dev)
**Role**: Platform administrator
**Capabilities**:
- Create Portfolio Manager accounts
- Access client data (with authorization)
- Manage price reference database (Brick 2)
- Import Excel price references

### 👑 Portfolio Manager
**Role**: Main client user managing entire real estate portfolio
**Capabilities**:
- Create/manage Site Manager profiles
- Assign sites to site managers
- Create/manage asset structure (sites, buildings, equipment)
- Upload & validate AI-extracted contracts
- Manually create/modify contracts
- Link equipment to classifications
- View all contracts with filters
- Manage organizations & contacts
- Generate PDF reports
- View savings potential (Brick 2)
- Configure email notifications (Brick 2)

### 🏢 Site Manager
**Role**: Limited user managing specific site(s)
**Capabilities**:
- View contracts for assigned site(s)
- Upload contracts for their scope
- View equipment lists for their site
- Generate PDF reports for their site
- View savings for their site (Brick 2)
- Receive alerts for their site (Brick 2)

## Beneficiaries

### **Primary Beneficiaries**:
- **Real Estate Portfolio Managers**: Organizations managing multiple properties who need to centralize and monitor maintenance contracts
- **Facility Management Companies**: Teams responsible for building maintenance and compliance
- **Property Owners**: Landlords/owners seeking to optimize contract costs and ensure compliance

### **Secondary Beneficiaries**:
- **Site/Building Managers**: On-site staff who need quick access to contract information
- **Finance/Procurement Teams**: Teams analyzing costs and identifying savings opportunities
- **Compliance Officers**: Staff ensuring contractual obligations and deadlines are met

### **Economic Benefits**:
- Reduction in administrative time through AI automation (OCR + data extraction)
- Cost savings identification through price comparison
- Risk mitigation through deadline alerts (avoiding penalties/lapses)
- Improved decision-making through centralized data and analytics

## Technical Stack
- **Hosting**: France-based secure hosting (€50/month)
- **AI Services**: Mistral OCR (~€0.10/contract) + OpenRouter LLM
- **Security**: HTTPS, data isolation between clients, 3-tier user authentication
- **Interface**: Responsive web application with client's graphic charter

## Explicitly Excluded Features
- External Service Provider portal access
- Intervention request management
- Insurance claims management
- Task tracking/action plans
- Investment planning
- Electronic signatures
- Native mobile apps
- Third-party API integrations
- Financial health monitoring of service providers
