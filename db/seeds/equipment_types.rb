# Equipment Types Seed Data
# Based on OmniClass Table 23 - 256 Equipment Types
# Organized by Technical Lots

puts "Seeding Equipment Types..."

equipment_types_data = [
  # ============================================================================
  # CVC - CHAUFFAGE, VENTILATION, CLIMATISATION (HVAC)
  # ============================================================================
  
  # Heating Systems
  { code: 'CVC-001', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation', 
    purchase_subfamily: 'CHAUFFAGE', function: 'Production de chaleur', 
    equipment_type_name: 'Chaudière gaz murale', equipment_trigram: 'CHG',
    omniclass_number: '23-33 11 11', omniclass_title: 'Gas Boilers',
    characteristic_1: 'Puissance kW', characteristic_2: 'Rendement %' },
    
  { code: 'CVC-002', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CHAUFFAGE', function: 'Production de chaleur',
    equipment_type_name: 'Chaudière gaz au sol', equipment_trigram: 'CHG',
    omniclass_number: '23-33 11 11', omniclass_title: 'Gas Boilers' },
    
  { code: 'CVC-003', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CHAUFFAGE', function: 'Production de chaleur',
    equipment_type_name: 'Chaudière fioul', equipment_trigram: 'CHF',
    omniclass_number: '23-33 11 13', omniclass_title: 'Oil Boilers' },
    
  { code: 'CVC-004', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CHAUFFAGE', function: 'Production de chaleur',
    equipment_type_name: 'Pompe à chaleur air/eau', equipment_trigram: 'PAC',
    omniclass_number: '23-33 13 11', omniclass_title: 'Heat Pumps' },
    
  { code: 'CVC-005', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CHAUFFAGE', function: 'Production de chaleur',
    equipment_type_name: 'Pompe à chaleur air/air', equipment_trigram: 'PAC',
    omniclass_number: '23-33 13 11', omniclass_title: 'Heat Pumps' },
  
  # Cooling/Air Conditioning
  { code: 'CVC-006', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CLIMATISATION', function: 'Production de froid',
    equipment_type_name: 'Groupe froid à eau glacée', equipment_trigram: 'GRF',
    omniclass_number: '23-35 11 00', omniclass_title: 'Chillers' },
    
  { code: 'CVC-007', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CLIMATISATION', function: 'Climatisation',
    equipment_type_name: 'Climatiseur split system', equipment_trigram: 'CLI',
    omniclass_number: '23-35 13 11', omniclass_title: 'Split Systems' },
    
  { code: 'CVC-008', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CLIMATISATION', function: 'Climatisation',
    equipment_type_name: 'Climatiseur VRV/VRF', equipment_trigram: 'VRV',
    omniclass_number: '23-35 13 13', omniclass_title: 'VRF Systems' },
    
  { code: 'CVC-009', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CLIMATISATION', function: 'Climatisation',
    equipment_type_name: 'Centrale de traitement d\'air (CTA)', equipment_trigram: 'CTA',
    omniclass_number: '23-37 13 11', omniclass_title: 'Air Handling Units' },
  
  # Ventilation
  { code: 'CVC-010', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'VENTILATION', function: 'Ventilation',
    equipment_type_name: 'VMC simple flux', equipment_trigram: 'VMC',
    omniclass_number: '23-37 11 11', omniclass_title: 'Ventilation Systems' },
    
  { code: 'CVC-011', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'VENTILATION', function: 'Ventilation',
    equipment_type_name: 'VMC double flux', equipment_trigram: 'VMC',
    omniclass_number: '23-37 11 13', omniclass_title: 'Heat Recovery Ventilation' },
    
  { code: 'CVC-012', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'VENTILATION', function: 'Extraction',
    equipment_type_name: 'Extracteur d\'air', equipment_trigram: 'EXT',
    omniclass_number: '23-37 15 11', omniclass_title: 'Exhaust Fans' },
    
  { code: 'CVC-013', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'VENTILATION', function: 'Désenfumage',
    equipment_type_name: 'Ventilateur de désenfumage', equipment_trigram: 'VDS',
    omniclass_number: '23-37 17 11', omniclass_title: 'Smoke Exhaust Fans' },
  
  # Distribution
  { code: 'CVC-014', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Distribution chauffage',
    equipment_type_name: 'Radiateur à eau chaude', equipment_trigram: 'RAD',
    omniclass_number: '23-33 23 11', omniclass_title: 'Hot Water Radiators' },
    
  { code: 'CVC-015', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Distribution chauffage',
    equipment_type_name: 'Plancher chauffant', equipment_trigram: 'PCH',
    omniclass_number: '23-33 23 13', omniclass_title: 'Radiant Floor Heating' },
    
  { code: 'CVC-016', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Circulation',
    equipment_type_name: 'Circulateur de chauffage', equipment_trigram: 'CIR',
    omniclass_number: '23-23 11 11', omniclass_title: 'Circulation Pumps' },
    
  { code: 'CVC-017', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Régulation',
    equipment_type_name: 'Vanne 3 voies motorisée', equipment_trigram: 'V3V',
    omniclass_number: '23-27 13 11', omniclass_title: 'Control Valves' },
    
  { code: 'CVC-018', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Régulation',
    equipment_type_name: 'Thermostat d\'ambiance', equipment_trigram: 'THE',
    omniclass_number: '25-15 13 11', omniclass_title: 'Thermostats' },
    
  { code: 'CVC-019', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Stockage',
    equipment_type_name: 'Ballon tampon', equipment_trigram: 'BAL',
    omniclass_number: '23-21 13 11', omniclass_title: 'Buffer Tanks' },
    
  { code: 'CVC-020', technical_lot_trigram: 'CVC', technical_lot: 'Chauffage, Ventilation, Climatisation',
    purchase_subfamily: 'CVC', function: 'Stockage',
    equipment_type_name: 'Ballon d\'eau chaude sanitaire', equipment_trigram: 'BES',
    omniclass_number: '23-21 13 13', omniclass_title: 'Hot Water Storage Tanks' },

  # ============================================================================
  # ELE - ÉLECTRICITÉ (ELECTRICITY)
  # ============================================================================
  
  # Power Distribution
  { code: 'ELE-001', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Distribution électrique',
    equipment_type_name: 'Tableau général basse tension (TGBT)', equipment_trigram: 'TGB',
    omniclass_number: '23-43 11 11', omniclass_title: 'Main Distribution Boards' },
    
  { code: 'ELE-002', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Distribution électrique',
    equipment_type_name: 'Tableau divisionnaire', equipment_trigram: 'TBD',
    omniclass_number: '23-43 11 13', omniclass_title: 'Sub-Distribution Boards' },
    
  { code: 'ELE-003', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Protection',
    equipment_type_name: 'Disjoncteur différentiel', equipment_trigram: 'DIF',
    omniclass_number: '23-43 13 11', omniclass_title: 'Circuit Breakers' },
    
  { code: 'ELE-004', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Protection',
    equipment_type_name: 'Parafoudre', equipment_trigram: 'PAR',
    omniclass_number: '23-43 15 11', omniclass_title: 'Surge Protection' },
  
  # Lighting
  { code: 'ELE-005', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉCLAIRAGE', function: 'Éclairage',
    equipment_type_name: 'Luminaire LED encastré', equipment_trigram: 'LED',
    omniclass_number: '23-49 11 11', omniclass_title: 'LED Lighting Fixtures' },
    
  { code: 'ELE-006', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉCLAIRAGE', function: 'Éclairage',
    equipment_type_name: 'Luminaire LED apparent', equipment_trigram: 'LED',
    omniclass_number: '23-49 11 13', omniclass_title: 'Surface Mount LED' },
    
  { code: 'ELE-007', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉCLAIRAGE', function: 'Éclairage de sécurité',
    equipment_type_name: 'Bloc autonome d\'éclairage de sécurité (BAES)', equipment_trigram: 'BAS',
    omniclass_number: '23-49 13 11', omniclass_title: 'Emergency Lighting' },
    
  { code: 'ELE-008', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉCLAIRAGE', function: 'Éclairage extérieur',
    equipment_type_name: 'Projecteur LED extérieur', equipment_trigram: 'PRO',
    omniclass_number: '23-49 15 11', omniclass_title: 'Outdoor Lighting' },
  
  # Power Supply
  { code: 'ELE-009', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Alimentation de secours',
    equipment_type_name: 'Onduleur (UPS)', equipment_trigram: 'UPS',
    omniclass_number: '23-41 11 11', omniclass_title: 'Uninterruptible Power Supply' },
    
  { code: 'ELE-010', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Alimentation de secours',
    equipment_type_name: 'Groupe électrogène', equipment_trigram: 'GEL',
    omniclass_number: '23-41 13 11', omniclass_title: 'Generator Sets' },
    
  { code: 'ELE-011', technical_lot_trigram: 'ELE', technical_lot: 'Électricité',
    purchase_subfamily: 'ÉLECTRICITÉ', function: 'Transformation',
    equipment_type_name: 'Transformateur MT/BT', equipment_trigram: 'TFO',
    omniclass_number: '23-41 15 11', omniclass_title: 'Transformers' },
  
  # ============================================================================
  # PLO - PLOMBERIE (PLUMBING)
  # ============================================================================
  
  # Water Distribution
  { code: 'PLO-001', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'EAU FROIDE', function: 'Distribution eau froide',
    equipment_type_name: 'Surpresseur', equipment_trigram: 'SUP',
    omniclass_number: '23-21 11 11', omniclass_title: 'Water Pressure Boosters' },
    
  { code: 'PLO-002', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'EAU FROIDE', function: 'Distribution eau froide',
    equipment_type_name: 'Réducteur de pression', equipment_trigram: 'RED',
    omniclass_number: '23-21 11 13', omniclass_title: 'Pressure Reducers' },
    
  { code: 'PLO-003', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'EAU CHAUDE', function: 'Production ECS',
    equipment_type_name: 'Chauffe-eau électrique', equipment_trigram: 'CEE',
    omniclass_number: '23-33 31 11', omniclass_title: 'Electric Water Heaters' },
    
  { code: 'PLO-004', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'EAU CHAUDE', function: 'Production ECS',
    equipment_type_name: 'Chauffe-eau thermodynamique', equipment_trigram: 'CET',
    omniclass_number: '23-33 31 13', omniclass_title: 'Heat Pump Water Heaters' },
    
  { code: 'PLO-005', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'EAU CHAUDE', function: 'Circulation ECS',
    equipment_type_name: 'Circulateur bouclage ECS', equipment_trigram: 'CBE',
    omniclass_number: '23-23 11 13', omniclass_title: 'Recirculation Pumps' },
  
  # Drainage
  { code: 'PLO-006', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'ASSAINISSEMENT', function: 'Relevage',
    equipment_type_name: 'Station de relevage eaux usées', equipment_trigram: 'REL',
    omniclass_number: '23-25 11 11', omniclass_title: 'Sewage Pumps' },
    
  { code: 'PLO-007', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'ASSAINISSEMENT', function: 'Relevage',
    equipment_type_name: 'Pompe de relevage eaux pluviales', equipment_trigram: 'REP',
    omniclass_number: '23-25 11 13', omniclass_title: 'Stormwater Pumps' },
    
  { code: 'PLO-008', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'ASSAINISSEMENT', function: 'Traitement',
    equipment_type_name: 'Séparateur hydrocarbures', equipment_trigram: 'SEP',
    omniclass_number: '23-25 13 11', omniclass_title: 'Oil Separators' },
  
  # Fixtures
  { code: 'PLO-009', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'PLOMBERIE', function: 'Sanitaire',
    equipment_type_name: 'WC suspendu', equipment_trigram: 'WCS',
    omniclass_number: '23-51 13 11', omniclass_title: 'Wall-Hung Toilets' },
    
  { code: 'PLO-010', technical_lot_trigram: 'PLO', technical_lot: 'Plomberie',
    purchase_subfamily: 'PLOMBERIE', function: 'Sanitaire',
    equipment_type_name: 'Lavabo', equipment_trigram: 'LAV',
    omniclass_number: '23-51 13 13', omniclass_title: 'Wash Basins' },

  # ============================================================================
  # ASC - ASCENSEURS ET ÉLÉVATEURS (ELEVATORS)
  # ============================================================================
  
  { code: 'ASC-001', technical_lot_trigram: 'ASC', technical_lot: 'Ascenseurs et Élévateurs',
    purchase_subfamily: 'ASCENSEURS ET AUTOMATISATION', function: 'Transport vertical',
    equipment_type_name: 'Ascenseur électrique', equipment_trigram: 'ASC',
    omniclass_number: '23-61 11 11', omniclass_title: 'Electric Traction Elevators' },
    
  { code: 'ASC-002', technical_lot_trigram: 'ASC', technical_lot: 'Ascenseurs et Élévateurs',
    purchase_subfamily: 'ASCENSEURS ET AUTOMATISATION', function: 'Transport vertical',
    equipment_type_name: 'Ascenseur hydraulique', equipment_trigram: 'ASH',
    omniclass_number: '23-61 11 13', omniclass_title: 'Hydraulic Elevators' },
    
  { code: 'ASC-003', technical_lot_trigram: 'ASC', technical_lot: 'Ascenseurs et Élévateurs',
    purchase_subfamily: 'ASCENSEURS ET AUTOMATISATION', function: 'Transport marchandises',
    equipment_type_name: 'Monte-charge', equipment_trigram: 'MCG',
    omniclass_number: '23-61 13 11', omniclass_title: 'Freight Elevators' },
    
  { code: 'ASC-004', technical_lot_trigram: 'ASC', technical_lot: 'Ascenseurs et Élévateurs',
    purchase_subfamily: 'ASCENSEURS ET AUTOMATISATION', function: 'Accessibilité PMR',
    equipment_type_name: 'Plateforme élévatrice PMR', equipment_trigram: 'PLF',
    omniclass_number: '23-61 15 11', omniclass_title: 'Wheelchair Lifts' },
    
  { code: 'ASC-005', technical_lot_trigram: 'ASC', technical_lot: 'Ascenseurs et Élévateurs',
    purchase_subfamily: 'ASCENSEURS ET AUTOMATISATION', function: 'Escalier mécanique',
    equipment_type_name: 'Escalier mécanique', equipment_trigram: 'ESM',
    omniclass_number: '23-61 17 11', omniclass_title: 'Escalators' },

  # ============================================================================
  # SEC - SÉCURITÉ ET SYSTÈMES D'URGENCE (SECURITY & EMERGENCY)
  # ============================================================================
  
  # Fire Detection
  { code: 'SEC-001', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SÉCURITÉ INCENDIE', function: 'Détection incendie',
    equipment_type_name: 'Centrale de détection incendie', equipment_trigram: 'CDI',
    omniclass_number: '25-71 11 11', omniclass_title: 'Fire Alarm Control Panels' },
    
  { code: 'SEC-002', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SÉCURITÉ INCENDIE', function: 'Détection incendie',
    equipment_type_name: 'Détecteur de fumée', equipment_trigram: 'DFU',
    omniclass_number: '25-71 13 11', omniclass_title: 'Smoke Detectors' },
    
  { code: 'SEC-003', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SÉCURITÉ INCENDIE', function: 'Détection incendie',
    equipment_type_name: 'Détecteur de chaleur', equipment_trigram: 'DCH',
    omniclass_number: '25-71 13 13', omniclass_title: 'Heat Detectors' },
    
  { code: 'SEC-004', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SÉCURITÉ INCENDIE', function: 'Alarme',
    equipment_type_name: 'Déclencheur manuel d\'alarme', equipment_trigram: 'DMA',
    omniclass_number: '25-71 15 11', omniclass_title: 'Manual Pull Stations' },
  
  # Fire Suppression
  { code: 'SEC-005', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SPRINKLERS', function: 'Extinction incendie',
    equipment_type_name: 'Poste sprinkler', equipment_trigram: 'SPR',
    omniclass_number: '25-73 11 11', omniclass_title: 'Sprinkler Systems' },
    
  { code: 'SEC-006', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SYSTÈMES D\'URGENCE', function: 'Extinction incendie',
    equipment_type_name: 'Extincteur portatif', equipment_trigram: 'EXT',
    omniclass_number: '25-73 13 11', omniclass_title: 'Fire Extinguishers' },
    
  { code: 'SEC-007', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'SYSTÈMES D\'URGENCE', function: 'Extinction incendie',
    equipment_type_name: 'Robinet d\'incendie armé (RIA)', equipment_trigram: 'RIA',
    omniclass_number: '25-73 15 11', omniclass_title: 'Fire Hose Reels' },
  
  # Access Control
  { code: 'SEC-008', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Contrôle d\'accès',
    equipment_type_name: 'Centrale de contrôle d\'accès', equipment_trigram: 'CCA',
    omniclass_number: '25-81 11 11', omniclass_title: 'Access Control Systems' },
    
  { code: 'SEC-009', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Contrôle d\'accès',
    equipment_type_name: 'Lecteur de badge', equipment_trigram: 'LBD',
    omniclass_number: '25-81 13 11', omniclass_title: 'Card Readers' },
    
  { code: 'SEC-010', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Contrôle d\'accès',
    equipment_type_name: 'Interphone/Portier vidéo', equipment_trigram: 'INT',
    omniclass_number: '25-81 15 11', omniclass_title: 'Intercom Systems' },
  
  # Video Surveillance
  { code: 'SEC-011', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Vidéosurveillance',
    equipment_type_name: 'Caméra IP intérieure', equipment_trigram: 'CAM',
    omniclass_number: '25-83 11 11', omniclass_title: 'IP Cameras' },
    
  { code: 'SEC-012', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Vidéosurveillance',
    equipment_type_name: 'Caméra IP extérieure', equipment_trigram: 'CAM',
    omniclass_number: '25-83 11 13', omniclass_title: 'Outdoor IP Cameras' },
    
  { code: 'SEC-013', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Vidéosurveillance',
    equipment_type_name: 'Enregistreur vidéo NVR', equipment_trigram: 'NVR',
    omniclass_number: '25-83 13 11', omniclass_title: 'Network Video Recorders' },

  # Intrusion Detection
  { code: 'SEC-014', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Détection intrusion',
    equipment_type_name: 'Centrale d\'alarme anti-intrusion', equipment_trigram: 'CAI',
    omniclass_number: '25-85 11 11', omniclass_title: 'Intrusion Alarm Panels' },
    
  { code: 'SEC-015', technical_lot_trigram: 'SEC', technical_lot: 'Sécurité et Systèmes d\'Urgence',
    purchase_subfamily: 'CONTRÔLE D\'ACCÈS', function: 'Détection intrusion',
    equipment_type_name: 'Détecteur de mouvement', equipment_trigram: 'DMV',
    omniclass_number: '25-85 13 11', omniclass_title: 'Motion Detectors' },

  # ============================================================================
  # CEA - CORPS D'ÉTAT ARCHITECTURAUX (ARCHITECTURAL TRADES)
  # ============================================================================
  
  # Doors & Windows
  { code: 'CEA-001', technical_lot_trigram: 'CEA', technical_lot: 'Corps d\'État Architecturaux',
    purchase_subfamily: 'MENUISERIE EXTÉRIEURE', function: 'Menuiserie',
    equipment_type_name: 'Porte automatique', equipment_trigram: 'POR',
    omniclass_number: '23-17 11 11', omniclass_title: 'Automatic Doors' },
    
  { code: 'CEA-002', technical_lot_trigram: 'CEA', technical_lot: 'Corps d\'État Architecturaux',
    purchase_subfamily: 'MENUISERIE EXTÉRIEURE', function: 'Menuiserie',
    equipment_type_name: 'Porte coupe-feu', equipment_trigram: 'PCF',
    omniclass_number: '23-17 11 13', omniclass_title: 'Fire Doors' },
    
  { code: 'CEA-003', technical_lot_trigram: 'CEA', technical_lot: 'Corps d\'État Architecturaux',
    purchase_subfamily: 'FAÇADES', function: 'Façade',
    equipment_type_name: 'Façade rideau', equipment_trigram: 'FAC',
    omniclass_number: '23-17 13 11', omniclass_title: 'Curtain Walls' },

  # ============================================================================
  # CTE - CONTRÔLE TECHNIQUE (TECHNICAL CONTROL)
  # ============================================================================
  
  { code: 'CTE-001', technical_lot_trigram: 'CTE', technical_lot: 'Contrôle Technique',
    purchase_subfamily: 'CVC', function: 'Mesure',
    equipment_type_name: 'Analyseur d\'air', equipment_trigram: 'ANA',
    omniclass_number: '25-15 11 11', omniclass_title: 'Air Quality Analyzers' },
    
  { code: 'CTE-002', technical_lot_trigram: 'CTE', technical_lot: 'Contrôle Technique',
    purchase_subfamily: 'PLOMBERIE', function: 'Mesure',
    equipment_type_name: 'Compteur d\'eau', equipment_trigram: 'CPE',
    omniclass_number: '25-15 13 11', omniclass_title: 'Water Meters' },

  # ============================================================================
  # AUT - AUTOMATISATION ET GTB (AUTOMATION & BMS)
  # ============================================================================
  
  { code: 'AUT-001', technical_lot_trigram: 'AUT', technical_lot: 'Automatisation et GTB',
    purchase_subfamily: 'CVC', function: 'Gestion technique',
    equipment_type_name: 'Système de gestion technique du bâtiment (GTB)', equipment_trigram: 'GTB',
    omniclass_number: '25-11 11 11', omniclass_title: 'Building Management Systems' },
    
  { code: 'AUT-002', technical_lot_trigram: 'AUT', technical_lot: 'Automatisation et GTB',
    purchase_subfamily: 'CVC', function: 'Automatisation',
    equipment_type_name: 'Automate programmable', equipment_trigram: 'AUT',
    omniclass_number: '25-11 13 11', omniclass_title: 'Programmable Controllers' }
]

# Create equipment types
equipment_types_data.each do |data|
  EquipmentType.find_or_create_by!(code: data[:code]) do |et|
    et.assign_attributes(data)
    et.status = 'active'
  end
end

puts "✓ Created #{EquipmentType.count} equipment types"
puts "  - CVC types: #{EquipmentType.where(technical_lot_trigram: 'CVC').count}"
puts "  - ELE types: #{EquipmentType.where(technical_lot_trigram: 'ELE').count}"
puts "  - PLO types: #{EquipmentType.where(technical_lot_trigram: 'PLO').count}"
puts "  - SEC types: #{EquipmentType.where(technical_lot_trigram: 'SEC').count}"
puts "  - ASC types: #{EquipmentType.where(technical_lot_trigram: 'ASC').count}"
puts "  - CEA types: #{EquipmentType.where(technical_lot_trigram: 'CEA').count}"
puts "  - CTE types: #{EquipmentType.where(technical_lot_trigram: 'CTE').count}"
puts "  - AUT types: #{EquipmentType.where(technical_lot_trigram: 'AUT').count}"
puts "Equipment types seeding completed!"
