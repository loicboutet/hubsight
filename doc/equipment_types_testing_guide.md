# Equipment Types Implementation - Testing Guide

This document provides step-by-step instructions to verify that the Equipment Types feature (Task 19) has been successfully implemented.

## 📋 Testing Checklist

- [ ] Database schema verification
- [ ] Seed data verification
- [ ] Model associations verification
- [ ] Equipment type assignment verification
- [ ] Portfolio page functionality test

---

## 1️⃣ Database Schema Verification

### Check if equipment_types table exists

```bash
cd /home/bazlur/loic/hubsight
bin/rails dbconsole
```

Then run:

```sql
-- Check table structure
.schema equipment_types

-- Check if table has data
SELECT COUNT(*) as total_types FROM equipment_types;

-- Expected result: 68 rows

-- Check distribution by technical lot
SELECT technical_lot_trigram, COUNT(*) as count 
FROM equipment_types 
GROUP BY technical_lot_trigram 
ORDER BY technical_lot_trigram;

-- Expected results:
-- ASC: 5
-- AUT: 2
-- CEA: 3
-- CTE: 2
-- CVC: 20
-- ELE: 11
-- PLO: 10
-- SEC: 15
```

### Check equipment_type_id column in equipment table

```sql
-- Check if foreign key column exists
.schema equipment

-- Should show: equipment_type_id INTEGER REFERENCES equipment_types(id)

-- Check equipment with types assigned
SELECT COUNT(*) as equipment_with_types 
FROM equipment 
WHERE equipment_type_id IS NOT NULL;

-- Expected result: 5 (from seed data)

-- Exit database console
.quit
```

---

## 2️⃣ Rails Console Verification

```bash
bin/rails console
```

Then run these commands:

### Check EquipmentType model

```ruby
# Count total equipment types
EquipmentType.count
# => 68

# Check by technical lot
EquipmentType.where(technical_lot_trigram: 'CVC').count
# => 20

EquipmentType.where(technical_lot_trigram: 'ELE').count
# => 11

# Get a sample equipment type
sample = EquipmentType.first
sample.display_name
# => "CVC-001 - Chaudière gaz murale"

sample.technical_lot_name
# => "Chauffage, Ventilation, Climatisation"

sample.lot_badge_color
# => "blue"

# Check for specific codes
EquipmentType.find_by(code: 'CVC-001')&.equipment_type_name
# => "Chaudière gaz murale"

EquipmentType.find_by(code: 'ELE-005')&.equipment_type_name
# => "Luminaire LED encastré"

EquipmentType.find_by(code: 'SEC-008')&.equipment_type_name
# => "Centrale de contrôle d'accès"
```

### Check Equipment associations

```ruby
# Find equipment with type assigned
eq = Equipment.where.not(equipment_type_id: nil).first

# Check association works
eq.equipment_type
# => Should return an EquipmentType object

eq.equipment_type&.display_name
# => Something like "CVC-007 - Climatiseur split system"

eq.equipment_type&.technical_lot_name
# => "Chauffage, Ventilation, Climatisation"

# Check reverse association
sample_type = EquipmentType.find_by(code: 'CVC-007')
sample_type.equipment.count
# => Should return count of equipment using this type

# Exit console
exit
```

---

## 3️⃣ Model Association Tests

Create a test file to verify associations:

```bash
bin/rails console
```

```ruby
# Test 1: EquipmentType can have multiple equipment
type = EquipmentType.create!(
  code: 'TEST-001',
  equipment_type_name: 'Test Equipment',
  technical_lot_trigram: 'CVC',
  technical_lot: 'Test Lot',
  status: 'active'
)

org = Organization.first
space = Space.first

eq1 = Equipment.create!(
  name: 'Test Equipment 1',
  organization: org,
  space: space,
  manufacturer: 'Test',
  status: 'active',
  equipment_type: type
)

eq2 = Equipment.create!(
  name: 'Test Equipment 2',
  organization: org,
  space: space,
  manufacturer: 'Test',
  status: 'active',
  equipment_type: type
)

# Verify association
type.equipment.count
# => 2

# Cleanup
eq1.destroy
eq2.destroy
type.destroy

exit
```

---

## 4️⃣ Portfolio Page Test

### Test the original error is fixed

```bash
# Start the Rails server if not running
bin/rails server
```

Then visit: http://localhost:3000/portfolio

