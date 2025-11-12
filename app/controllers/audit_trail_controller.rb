class AuditTrailController < ApplicationController
  def index
    # For now, this is a placeholder implementation
    # In production, this would integrate with PaperTrail or similar auditing gem
    @audit_entries = []
    
    # Sample audit data structure for demonstration using dummy user
    @sample_entries = [
      {
        user: 'admin@example.com',
        action: 'created',
        resource: 'Contract',
        resource_id: 1,
        changes: { 'status' => [nil, 'active'] },
        created_at: 1.day.ago
      },
      {
        user: 'portfolio.manager@example.com',
        action: 'updated',
        resource: 'Equipment',
        resource_id: 5,
        changes: { 'name' => ['Old Name', 'New Name'] },
        created_at: 2.days.ago
      },
      {
        user: 'admin@example.com',
        action: 'deleted',
        resource: 'Site',
        resource_id: 3,
        changes: { 'name' => ['Old Site', nil] },
        created_at: 3.days.ago
      }
    ]
    
    @audit_entries = @sample_entries if Rails.env.development?
  end
end
