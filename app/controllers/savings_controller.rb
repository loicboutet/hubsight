class SavingsController < ApplicationController
  include DataScoping
  
  before_action :authenticate_user!
  before_action :check_savings_unlocked
  
  def index
    # Renders savings/index.html.erb
  end

  def report
    # Renders savings/report.html.erb
  end

  def export_selection
    require 'csv'
    
    # Parse the selected contract numbers from the request
    contract_numbers = JSON.parse(params[:contract_numbers] || '[]')
    
    # Mock data matching the view
    all_contracts = [
      {number: "CTR-2025-001", site: "Tour Montparnasse\nTour A", provider: "OTIS France", family: "Maintenance", subfamily: "ascenseurs", amount: 24500, price_min: 18000, price_max: 22000, savings: 4300, termination_date: "31/03/2025"},
      {number: "CTR-2025-002", site: "Campus La Défense", provider: "Clean Pro Services", family: "Nettoyage", subfamily: "Bureaux", amount: 12800, price_min: 9500, price_max: 11500, savings: 2100, termination_date: "15/04/2025"},
      {number: "CTR-2024-189", site: "Centre Commercial", provider: "Bureau Veritas", family: "Contrôle", subfamily: "Électricité", amount: 8500, price_min: 6800, price_max: 7800, savings: 1200, termination_date: "30/06/2025"},
      {number: "CTR-2025-003", site: "Site Industriel", provider: "Daikin Service", family: "Maintenance", subfamily: "CVC", amount: 31200, price_min: 21000, price_max: 25000, savings: 7800, termination_date: "28/02/2025"},
      {number: "CTR-2024-188", site: "Résidence Le Parc", provider: "Vert Nature SARL", family: "Nettoyage", subfamily: "Espaces verts", amount: 6400, price_min: 5000, price_max: 5800, savings: 900, termination_date: "31/05/2025"},
      {number: "CTR-2025-004", site: "Campus La Défense", provider: "ALS Laboratoires", family: "Contrôle", subfamily: "Légionelle", amount: 4200, price_min: 3200, price_max: 3800, savings: 650, termination_date: "30/04/2025"},
      {number: "CTR-2024-187", site: "Tour Montparnasse", provider: "Portalp Service", family: "Maintenance", subfamily: "Portes", amount: 8900, price_min: 7000, price_max: 7900, savings: 1400, termination_date: "31/07/2025"},
      {number: "CTR-2025-005", site: "Immeuble Haussmann", provider: "Vitres Pro", family: "Nettoyage", subfamily: "Vitrerie", amount: 3600, price_min: 2800, price_max: 3200, savings: 580, termination_date: "15/03/2025"},
      {number: "CTR-2024-186", site: "Tous sites", provider: "EDF Entreprises", family: "Énergies", subfamily: "Électricité", amount: 125000, price_min: 98000, price_max: 112000, savings: 18500, termination_date: "31/12/2025"},
      {number: "CTR-2025-006", site: "Centre Commercial", provider: "3D Nuisibles", family: "Nettoyage", subfamily: "Nuisibles", amount: 2800, price_min: 2200, price_max: 2500, savings: 420, termination_date: "30/09/2025"},
      {number: "CTR-2024-185", site: "Site Industriel", provider: "Sicli Sécurité", family: "Sécurité", subfamily: "Incendie", amount: 5400, price_min: 4100, price_max: 4700, savings: 980, termination_date: "31/08/2025"},
      {number: "CTR-2025-007", site: "Centre Médical", provider: "Climatic Services", family: "Maintenance", subfamily: "Climatisation", amount: 18600, price_min: 14000, price_max: 16200, savings: 3200, termination_date: "30/06/2025"},
      {number: "CTR-2024-184", site: "Tous sites", provider: "AXA Assurances", family: "Assurance", subfamily: "Multi-risque", amount: 89000, price_min: 72000, price_max: 79000, savings: 12400, termination_date: "31/12/2025"},
      {number: "CTR-2025-008", site: "Campus Grenoble", provider: "Securitas France", family: "Sécurité", subfamily: "Gardiennage", amount: 156000, price_min: 118000, price_max: 135000, savings: 28600, termination_date: "31/01/2026"},
      {number: "CTR-2024-183", site: "Parc Roissy", provider: "Artiplomb SAS", family: "Maintenance", subfamily: "Plomberie", amount: 12000, price_min: 8800, price_max: 10200, savings: 2300, termination_date: "30/04/2025"}
    ]
    
    # Filter to only selected contracts
    selected_contracts = all_contracts.select { |c| contract_numbers.include?(c[:number]) }
    
    # Generate CSV (Excel-compatible)
    csv_data = CSV.generate(col_sep: "\t", encoding: 'UTF-8') do |csv|
      # Headers
      csv << [
        'N° Contrat',
        'Site',
        'Organisation Prestataire',
        'Famille',
        'Sous-Famille',
        'Montant Annuel HT',
        'Prix Min Référence',
        'Prix Max Référence',
        'Économie Potentielle Min',
        'Économie Potentielle Max',
        'Économie Min %',
        'Économie Max %',
        'Date Limite Résiliation'
      ]
      
      # Data rows
      selected_contracts.each do |contract|
        savings_min_pct = ((contract[:price_min].to_f / contract[:amount]) * 100 - 100).abs
        savings_max_pct = ((contract[:price_max].to_f / contract[:amount]) * 100 - 100).abs
        savings_min = contract[:amount] - contract[:price_min]
        savings_max = contract[:amount] - contract[:price_max]
        
        csv << [
          contract[:number],
          contract[:site].gsub("\n", " "),
          contract[:provider],
          contract[:family],
          contract[:subfamily],
          "#{contract[:amount]} €",
          "#{contract[:price_min]} €",
          "#{contract[:price_max]} €",
          "#{savings_min} €",
          "#{savings_max} €",
          "#{savings_min_pct.round(1)}%",
          "#{savings_max_pct.round(1)}%",
          contract[:termination_date]
        ]
      end
    end
    
    # Send file
    send_data csv_data,
      filename: "economies_potentielles_#{Time.current.strftime('%Y%m%d_%H%M%S')}.xls",
      type: 'application/vnd.ms-excel',
      disposition: 'attachment'
  end
  
  private
  
  # ASUS Task 1: Check if savings module is unlocked
  def check_savings_unlocked
    # Get contracts count based on user role
    contracts = scoped_contracts
    
    @contracts_count = contracts.count
    @savings_unlocked = (@contracts_count >= 5)
    @contracts_needed = [5 - @contracts_count, 0].max
    
    # Redirect to dashboard if not unlocked
    unless @savings_unlocked
      redirect_to dashboard_path, 
                  alert: "Le module Économies se déverrouille automatiquement après avoir importé 5 contrats. Il vous en manque #{@contracts_needed}."
    end
  end
end
