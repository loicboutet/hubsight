class AnalyticsController < ApplicationController
  def index
    # KPI Cards Data
    @total_budget = 847_500
    @budget_trend = "+5.2%"
    
    @total_contracts = 186
    @active_contracts = 154
    @renewal_contracts = 18
    @terminated_contracts = 14
    @coverage_percentage = 92
    
    @potential_savings = 127_350
    @savings_percentage = 4.5
    @analyzed_contracts = 58
    
    @total_alerts = 23
    @upcoming_alerts = 12
    @at_risk_alerts = 8
    @missing_contracts_alerts = 3
    
    # Contract Distribution by Purchase Family (Pie Chart Data)
    @contract_distribution = [
      { family: 'Maintenance', percentage: 42, count: 78, amount: 1_195_350 },
      { family: 'Nettoyage et Hygiène', percentage: 22, count: 41, amount: 626_450 },
      { family: 'Contrôles Techniques', percentage: 15, count: 28, amount: 427_125 },
      { family: 'Énergies/Fluides', percentage: 12, count: 22, amount: 341_700 },
      { family: 'Assurances', percentage: 5, count: 9, amount: 142_375 },
      { family: 'Immobilier', percentage: 3, count: 6, amount: 85_425 },
      { family: 'Autres', percentage: 1, count: 2, amount: 29_075 }
    ]
    
    # Monthly Contract Expirations (Bar Chart Data)
    @monthly_expirations = [
      { month: 'Jan 2025', count: 8 },
      { month: 'Fév 2025', count: 12 },
      { month: 'Mar 2025', count: 15 },
      { month: 'Avr 2025', count: 9 },
      { month: 'Mai 2025', count: 18 },
      { month: 'Juin 2025', count: 14 },
      { month: 'Juil 2025', count: 6 },
      { month: 'Août 2025', count: 4 },
      { month: 'Sept 2025', count: 11 },
      { month: 'Oct 2025', count: 16 },
      { month: 'Nov 2025', count: 13 },
      { month: 'Déc 2025', count: 10 }
    ]
    
    # Top 10 Contracts by Value
    @top_contracts = [
      { number: 'CTR-2024-001', title: 'Fourniture électricité', provider: 'EDF Entreprises', amount: 125_000, site: 'Tous sites', expiry: '31/12/2025' },
      { number: 'CTR-2024-HVAC-001', title: 'Maintenance CVC', provider: 'ENGIE Solutions', amount: 102_000, site: 'Tour Montparnasse', expiry: '31/01/2027' },
      { number: 'CTR-2025-SEC-001', title: 'Gardiennage 24/7', provider: 'Securitas France', amount: 156_000, site: 'Campus Grenoble', expiry: '31/12/2025' },
      { number: 'CTR-2024-ASS-001', title: 'Assurance multi-risque', provider: 'AXA Assurances', amount: 89_000, site: 'Tous sites', expiry: '31/12/2025' },
      { number: 'CTR-2024-009', title: 'Maintenance ascenseurs', provider: 'OTIS France', amount: 73_500, site: 'Campus La Défense', expiry: '15/06/2026' },
      { number: 'CTR-2024-CVC-002', title: 'Climatisation', provider: 'Daikin Service', amount: 62_400, site: 'Centre Commercial', expiry: '28/02/2026' },
      { number: 'CTR-2024-005', title: 'Nettoyage bureaux', provider: 'Clean Pro Services', amount: 48_900, site: 'Campus La Défense', expiry: '09/01/2026' },
      { number: 'CTR-2024-012', title: 'Maintenance multi-technique', provider: 'Bouygues ES', amount: 95_600, site: 'Parc Roissy', expiry: '15/08/2026' },
      { number: 'CTR-2024-PLO-003', title: 'Plomberie et chauffage', provider: 'Artiplomb SAS', amount: 38_200, site: 'Site Industriel', expiry: '04/12/2025' },
      { number: 'CTR-2024-ASC-007', title: 'Maintenance ascenseurs', provider: 'Schindler France', amount: 55_800, site: 'Centre Médical', expiry: '22/03/2026' }
    ]
    
    # Top Savings Opportunities (BRIQUE 2)
    @savings_opportunities = [
      { number: 'CTR-2024-CLN-012', family: 'Nettoyage', current_price: 18_500, reference_price: 14_200, saving: 4_300, percentage: 23.2 },
      { number: 'CTR-2024-MNT-045', family: 'Maintenance', current_price: 25_000, reference_price: 21_500, saving: 3_500, percentage: 14.0 },
      { number: 'CTR-2024-PLO-008', family: 'Plomberie', current_price: 12_800, reference_price: 10_200, saving: 2_600, percentage: 20.3 },
      { number: 'CTR-2024-ELE-015', family: 'Électricité', current_price: 16_400, reference_price: 14_200, saving: 2_200, percentage: 13.4 },
      { number: 'CTR-2024-CVC-019', family: 'CVC', current_price: 22_100, reference_price: 20_000, saving: 2_100, percentage: 9.5 },
      { number: 'CTR-2024-SEC-023', family: 'Sécurité', current_price: 19_800, reference_price: 17_950, saving: 1_850, percentage: 9.3 },
      { number: 'CTR-2024-CLN-028', family: 'Nettoyage', current_price: 14_500, reference_price: 12_900, saving: 1_600, percentage: 11.0 },
      { number: 'CTR-2024-MNT-032', family: 'Maintenance', current_price: 18_700, reference_price: 17_250, saving: 1_450, percentage: 7.8 },
      { number: 'CTR-2024-CTR-035', family: 'Contrôle', current_price: 9_800, reference_price: 8_550, saving: 1_250, percentage: 12.8 },
      { number: 'CTR-2024-VER-041', family: 'Espaces verts', current_price: 11_200, reference_price: 10_100, saving: 1_100, percentage: 9.8 }
    ]
    
    # Contract Distribution by Site
    @site_distribution = [
      { name: 'Tour Montparnasse', contracts: 23, amount: 385_600, area: 120_000, cost_per_sqm: 3.21, equipment: 487 },
      { name: 'Campus La Défense', contracts: 34, amount: 512_800, area: 85_500, cost_per_sqm: 6.00, equipment: 892 },
      { name: 'Centre Commercial Odysseum', contracts: 18, amount: 298_400, area: 65_000, cost_per_sqm: 4.59, equipment: 324 },
      { name: 'Site Industriel Lyon Nord', contracts: 29, amount: 445_200, area: 45_000, cost_per_sqm: 9.89, equipment: 567 },
      { name: 'Résidence Le Parc', contracts: 12, amount: 156_800, area: 12_500, cost_per_sqm: 12.54, equipment: 156 },
      { name: 'Parc d\'Activités Roissy', contracts: 21, amount: 378_900, area: 95_000, cost_per_sqm: 3.99, equipment: 445 },
      { name: 'Immeuble Haussmann', contracts: 8, amount: 98_500, area: 8_200, cost_per_sqm: 12.01, equipment: 89 },
      { name: 'Centre Médical Pasteur', contracts: 16, amount: 245_300, area: 15_600, cost_per_sqm: 15.72, equipment: 234 },
      { name: 'Campus Universitaire Grenoble', contracts: 27, amount: 456_700, area: 42_000, cost_per_sqm: 10.87, equipment: 678 },
      { name: 'Zone Commerciale Atlantis', contracts: 19, amount: 312_400, area: 52_000, cost_per_sqm: 6.01, equipment: 298 }
    ]
    
    # Additional Metrics
    @total_equipment = 3_947
    @equipment_under_contract = 3_254
    @equipment_no_contract = 693
    @equipment_coverage = 82
    
    @active_organizations = 45
    @avg_contracts_per_provider = 4.1
    @top_provider = { name: 'ENGIE Solutions', contracts: 12 }
    
    # Geographic Distribution
    @geographic_distribution = [
      { region: 'Île-de-France', percentage: 58, count: 108 },
      { region: 'PACA', percentage: 15, count: 28 },
      { region: 'Auvergne-Rhône-Alpes', percentage: 18, count: 33 },
      { region: 'Autres régions', percentage: 9, count: 17 }
    ]
  end
end
