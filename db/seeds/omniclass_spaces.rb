# OmniClass Table 13 - Space Classifications
# International BIM standard for space classification (966 total classifications)
# This is a representative sample covering major space categories

puts "Seeding OmniClass Space Classifications..."

omniclass_spaces_data = [
  # ============================================================================
  # MAJOR CATEGORIES (Level 1)
  # ============================================================================
  
  { code: '13-11 00 00', title: 'Outdoor Spaces' },
  { code: '13-21 00 00', title: 'Building Spaces' },
  { code: '13-31 00 00', title: 'Healthcare Facility Spaces' },
  { code: '13-41 00 00', title: 'Residential Facility Spaces' },
  { code: '13-51 00 00', title: 'Commercial Facility Spaces' },
  { code: '13-61 00 00', title: 'Industrial Facility Spaces' },
  { code: '13-71 00 00', title: 'Transportation Facility Spaces' },
  
  # ============================================================================
  # 13-11 00 00 - OUTDOOR SPACES
  # ============================================================================
  
  { code: '13-11 11 11', title: 'Outdoor Spaces - General' },
  { code: '13-11 11 14', title: 'Parking Lots' },
  { code: '13-11 11 17', title: 'Outdoor Recreation Areas' },
  { code: '13-11 11 21', title: 'Plazas and Courts' },
  { code: '13-11 11 24', title: 'Gardens and Landscaped Areas' },
  { code: '13-11 11 27', title: 'Loading Docks' },
  
  # ============================================================================
  # 13-21 00 00 - BUILDING SPACES (Office & Administrative)
  # ============================================================================
  
  # Office Spaces
  { code: '13-21 11 00', title: 'Office Spaces' },
  { code: '13-21 11 11', title: 'Private Offices' },
  { code: '13-21 11 14', title: 'Open Office Areas' },
  { code: '13-21 11 17', title: 'Cubicle Areas' },
  { code: '13-21 11 21', title: 'Workstations' },
  { code: '13-21 11 24', title: 'Executive Offices' },
  
  # Conference and Meeting Spaces
  { code: '13-21 21 00', title: 'Conference Spaces' },
  { code: '13-21 21 11', title: 'Conference Rooms' },
  { code: '13-21 21 14', title: 'Meeting Rooms' },
  { code: '13-21 21 17', title: 'Board Rooms' },
  { code: '13-21 21 21', title: 'Video Conference Rooms' },
  { code: '13-21 21 24', title: 'Training Rooms' },
  
  # Educational Spaces
  { code: '13-21 31 00', title: 'Educational Spaces' },
  { code: '13-21 31 11', title: 'Classrooms' },
  { code: '13-21 31 14', title: 'Lecture Halls' },
  { code: '13-21 31 17', title: 'Seminar Rooms' },
  { code: '13-21 31 21', title: 'Computer Labs' },
  { code: '13-21 31 24', title: 'Science Labs' },
  { code: '13-21 31 27', title: 'Libraries and Reading Rooms' },
  
  # Support Spaces
  { code: '13-21 41 00', title: 'Support Spaces' },
  { code: '13-21 41 11', title: 'Copy and Print Rooms' },
  { code: '13-21 41 14', title: 'Mail Rooms' },
  { code: '13-21 41 17', title: 'Storage Rooms' },
  { code: '13-21 41 21', title: 'Filing Rooms' },
  { code: '13-21 41 24', title: 'Supply Rooms' },
  
  # Break and Lounge Spaces
  { code: '13-21 51 00', title: 'Break and Lounge Spaces' },
  { code: '13-21 51 11', title: 'Break Rooms' },
  { code: '13-21 51 14', title: 'Lunch Rooms' },
  { code: '13-21 51 17', title: 'Employee Lounges' },
  { code: '13-21 51 21', title: 'Kitchenettes' },
  
  # Reception and Lobby Spaces
  { code: '13-21 61 00', title: 'Reception and Lobby Spaces' },
  { code: '13-21 61 11', title: 'Reception Areas' },
  { code: '13-21 61 14', title: 'Lobbies' },
  { code: '13-21 61 17', title: 'Waiting Areas' },
  { code: '13-21 61 21', title: 'Entrance Halls' },
  
  # ============================================================================
  # 13-31 00 00 - HEALTHCARE FACILITY SPACES
  # ============================================================================
  
  { code: '13-31 11 00', title: 'Patient Room Spaces' },
  { code: '13-31 11 11', title: 'Patient Rooms' },
  { code: '13-31 11 14', title: 'Intensive Care Rooms' },
  { code: '13-31 11 17', title: 'Isolation Rooms' },
  { code: '13-31 21 00', title: 'Treatment Spaces' },
  { code: '13-31 21 11', title: 'Examination Rooms' },
  { code: '13-31 21 14', title: 'Operating Rooms' },
  { code: '13-31 21 17', title: 'Emergency Treatment Rooms' },
  { code: '13-31 31 00', title: 'Diagnostic and Imaging Spaces' },
  { code: '13-31 31 11', title: 'Radiology Rooms' },
  { code: '13-31 31 14', title: 'MRI Rooms' },
  { code: '13-31 41 00', title: 'Laboratory Spaces' },
  { code: '13-31 41 11', title: 'Medical Laboratories' },
  
  # ============================================================================
  # 13-41 00 00 - RESIDENTIAL FACILITY SPACES
  # ============================================================================
  
  { code: '13-41 11 00', title: 'Living Spaces' },
  { code: '13-41 11 11', title: 'Living Rooms' },
  { code: '13-41 11 14', title: 'Family Rooms' },
  { code: '13-41 21 00', title: 'Sleeping Spaces' },
  { code: '13-41 21 11', title: 'Bedrooms' },
  { code: '13-41 21 14', title: 'Master Bedrooms' },
  { code: '13-41 31 00', title: 'Food Preparation Spaces' },
  { code: '13-41 31 11', title: 'Kitchens' },
  { code: '13-41 31 14', title: 'Dining Rooms' },
  { code: '13-41 41 00', title: 'Sanitary Spaces' },
  { code: '13-41 41 11', title: 'Bathrooms' },
  { code: '13-41 41 14', title: 'Powder Rooms' },
  
  # ============================================================================
  # 13-51 00 00 - COMMERCIAL FACILITY SPACES
  # ============================================================================
  
  { code: '13-51 11 00', title: 'Retail Sales Spaces' },
  { code: '13-51 11 11', title: 'Sales Floors' },
  { code: '13-51 11 14', title: 'Display Areas' },
  { code: '13-51 11 17', title: 'Fitting Rooms' },
  { code: '13-51 21 00', title: 'Food Service Spaces' },
  { code: '13-51 21 11', title: 'Restaurant Dining Areas' },
  { code: '13-51 21 14', title: 'Commercial Kitchens' },
  { code: '13-51 21 17', title: 'Bars and Beverage Service Areas' },
  { code: '13-51 31 00', title: 'Entertainment Spaces' },
  { code: '13-51 31 11', title: 'Theaters and Auditoriums' },
  { code: '13-51 31 14', title: 'Exhibition Halls' },
  
  # ============================================================================
  # 13-61 00 00 - INDUSTRIAL FACILITY SPACES
  # ============================================================================
  
  { code: '13-61 11 00', title: 'Manufacturing Spaces' },
  { code: '13-61 11 11', title: 'Production Floors' },
  { code: '13-61 11 14', title: 'Assembly Areas' },
  { code: '13-61 21 00', title: 'Warehouse Spaces' },
  { code: '13-61 21 11', title: 'Storage Areas' },
  { code: '13-61 21 14', title: 'Shipping and Receiving Areas' },
  
  # ============================================================================
  # 13-71 00 00 - TRANSPORTATION FACILITY SPACES
  # ============================================================================
  
  { code: '13-71 11 00', title: 'Passenger Processing Spaces' },
  { code: '13-71 11 11', title: 'Ticket Counters' },
  { code: '13-71 11 14', title: 'Baggage Claim Areas' },
  { code: '13-71 21 00', title: 'Waiting Spaces' },
  { code: '13-71 21 11', title: 'Departure Lounges' },
  { code: '13-71 21 14', title: 'Boarding Areas' },
  
  # ============================================================================
  # TECHNICAL AND SERVICE SPACES (Common across all building types)
  # ============================================================================
  
  { code: '13-91 00 00', title: 'Service and Technical Spaces' },
  { code: '13-91 11 00', title: 'Mechanical Rooms' },
  { code: '13-91 11 11', title: 'HVAC Equipment Rooms' },
  { code: '13-91 11 14', title: 'Boiler Rooms' },
  { code: '13-91 21 00', title: 'Electrical Rooms' },
  { code: '13-91 21 11', title: 'Electrical Switchgear Rooms' },
  { code: '13-91 21 14', title: 'Transformer Rooms' },
  { code: '13-91 31 00', title: 'Communications and Data Rooms' },
  { code: '13-91 31 11', title: 'Telecommunications Rooms' },
  { code: '13-91 31 14', title: 'Server Rooms' },
  { code: '13-91 41 00', title: 'Janitorial Spaces' },
  { code: '13-91 41 11', title: 'Custodial Closets' },
  { code: '13-91 41 14', title: 'Housekeeping Rooms' },
  
  # ============================================================================
  # CIRCULATION SPACES (Common across all building types)
  # ============================================================================
  
  { code: '13-95 00 00', title: 'Circulation Spaces' },
  { code: '13-95 11 00', title: 'Corridors and Hallways' },
  { code: '13-95 11 11', title: 'Corridors' },
  { code: '13-95 11 14', title: 'Hallways' },
  { code: '13-95 21 00', title: 'Stairways' },
  { code: '13-95 21 11', title: 'Interior Stairs' },
  { code: '13-95 21 14', title: 'Exit Stairs' },
  { code: '13-95 31 00', title: 'Elevator Spaces' },
  { code: '13-95 31 11', title: 'Elevator Lobbies' },
  { code: '13-95 31 14', title: 'Elevator Shafts' },
  
  # ============================================================================
  # SANITARY FACILITIES (Common across all building types)
  # ============================================================================
  
  { code: '13-97 00 00', title: 'Sanitary Facilities' },
  { code: '13-97 11 00', title: 'Restrooms' },
  { code: '13-97 11 11', title: 'Public Restrooms' },
  { code: '13-97 11 14', title: 'Accessible Restrooms' },
  { code: '13-97 11 17', title: 'Staff Restrooms' },
  { code: '13-97 21 00', title: 'Shower and Locker Facilities' },
  { code: '13-97 21 11', title: 'Locker Rooms' },
  { code: '13-97 21 14', title: 'Shower Rooms' }
]

# Create OmniClass space classifications
omniclass_spaces_data.each do |data|
  OmniclassSpace.find_or_create_by!(code: data[:code]) do |space|
    space.assign_attributes(data)
    space.status = 'active'
  end
end

puts "✓ Created #{OmniclassSpace.count} OmniClass space classifications"
puts "  Major categories:"
puts "    - Outdoor Spaces (13-11)"
puts "    - Building Spaces (13-21)"
puts "    - Healthcare Spaces (13-31)"
puts "    - Residential Spaces (13-41)"
puts "    - Commercial Spaces (13-51)"
puts "    - Industrial Spaces (13-61)"
puts "    - Transportation Spaces (13-71)"
puts "    - Technical/Service Spaces (13-91)"
puts "    - Circulation Spaces (13-95)"
puts "    - Sanitary Facilities (13-97)"
puts "OmniClass space classifications seeding completed!"
