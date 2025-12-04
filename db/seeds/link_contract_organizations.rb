# Link existing contracts to organization records based on contractor and client names
# Run via Admin UI: /admin/seeds

puts "=" * 80
puts "LINKING CONTRACTS TO ORGANIZATIONS"
puts "=" * 80
puts ""

total_contracts = Contract.count
puts "Total contracts to process: #{total_contracts}"
puts ""

# Initialize counters
stats = {
  contractor_linked: 0,
  contractor_not_found: 0,
  contractor_already_linked: 0,
  contractor_no_name: 0,
  client_linked: 0,
  client_not_found: 0,
  client_already_linked: 0,
  client_no_name: 0
}

unmatched_contractors = []
unmatched_clients = []

# Process each contract
Contract.find_each.with_index do |contract, index|
  puts "[#{index + 1}/#{total_contracts}] Processing: #{contract.contract_number}"
  
  # === LINK CONTRACTOR ORGANIZATION ===
  if contract.contractor_organization_id.present?
    puts "  → Contractor already linked: #{contract.contractor_organization.name}"
    stats[:contractor_already_linked] += 1
  elsif contract.contractor_organization_name.blank?
    puts "  → No contractor name to match"
    stats[:contractor_no_name] += 1
  else
    # Try exact match first
    org = Organization.find_by(name: contract.contractor_organization_name)
    
    # Try case-insensitive match if exact fails
    org ||= Organization.where("LOWER(name) = LOWER(?)", contract.contractor_organization_name).first
    
    # Try partial match if still not found
    org ||= Organization.where("name LIKE ?", "%#{contract.contractor_organization_name}%").first
    
    if org
      contract.update_columns(
        contractor_organization_id: org.id,
        contractor_organization_name: org.name
      )
      puts "  ✓ Contractor linked: #{org.name}"
      stats[:contractor_linked] += 1
    else
      puts "  ✗ No match for contractor: '#{contract.contractor_organization_name}'"
      stats[:contractor_not_found] += 1
      unmatched_contractors << contract.contractor_organization_name unless unmatched_contractors.include?(contract.contractor_organization_name)
    end
  end
  
  # === LINK CLIENT ORGANIZATION ===
  if contract.client_organization_id.present?
    puts "  → Client already linked: #{contract.client_organization.name}"
    stats[:client_already_linked] += 1
  elsif contract.client_organization_name.blank?
    puts "  → No client name to match"
    stats[:client_no_name] += 1
  else
    # Try exact match first
    org = Organization.find_by(name: contract.client_organization_name)
    
    # Try case-insensitive match if exact fails
    org ||= Organization.where("LOWER(name) = LOWER(?)", contract.client_organization_name).first
    
    # Try partial match if still not found
    org ||= Organization.where("name LIKE ?", "%#{contract.client_organization_name}%").first
    
    if org
      contract.update_columns(
        client_organization_id: org.id,
        client_organization_name: org.name
      )
      puts "  ✓ Client linked: #{org.name}"
      stats[:client_linked] += 1
    else
      puts "  ✗ No match for client: '#{contract.client_organization_name}'"
      stats[:client_not_found] += 1
      unmatched_clients << contract.client_organization_name unless unmatched_clients.include?(contract.client_organization_name)
    end
  end
  
  puts ""
end

# === SUMMARY ===
puts "=" * 80
puts "SUMMARY"
puts "=" * 80
puts ""
puts "CONTRACTOR ORGANIZATIONS:"
puts "  ✓ Linked successfully:     #{stats[:contractor_linked]}"
puts "  → Already linked:          #{stats[:contractor_already_linked]}"
puts "  ✗ No match found:          #{stats[:contractor_not_found]}"
puts "  - No name provided:        #{stats[:contractor_no_name]}"
puts ""
puts "CLIENT ORGANIZATIONS:"
puts "  ✓ Linked successfully:     #{stats[:client_linked]}"
puts "  → Already linked:          #{stats[:client_already_linked]}"
puts "  ✗ No match found:          #{stats[:client_not_found]}"
puts "  - No name provided:        #{stats[:client_no_name]}"
puts ""

# === UNMATCHED ORGANIZATIONS ===
if unmatched_contractors.any? || unmatched_clients.any?
  puts "=" * 80
  puts "UNMATCHED ORGANIZATIONS (Need to be created)"
  puts "=" * 80
  puts ""
  
  if unmatched_contractors.any?
    puts "CONTRACTORS (#{unmatched_contractors.size}):"
    unmatched_contractors.sort.each do |name|
      puts "  - #{name}"
    end
    puts ""
  end
  
  if unmatched_clients.any?
    puts "CLIENTS (#{unmatched_clients.size}):"
    unmatched_clients.sort.each do |name|
      puts "  - #{name}"
    end
    puts ""
  end
  
  puts "NEXT STEPS:"
  puts "1. Create the missing organizations via /organizations or /admin/organizations"
  puts "2. Re-run this seed: /admin/seeds -> 'Link Contract Organizations'"
  puts ""
else
  puts "✓ All contracts with organization names have been linked!"
  puts ""
end

puts "=" * 80
puts "DONE"
puts "=" * 80
