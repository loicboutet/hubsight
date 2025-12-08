# HP Task 3: Password Verification Backend for Deletion Modals
# This controller handles password verification and deletion logging
class DeletionVerificationsController < ApplicationController
  before_action :authenticate_user!
  
  # POST /deletion_verifications/verify_password
  def verify_password
    password = params[:password]
    
    if password.blank?
      render json: { 
        success: false, 
        error: "Le mot de passe est requis" 
      }, status: :bad_request
      return
    end
    
    # Verify password matches current user using Devise's valid_password? method
    if current_user.valid_password?(password)
      render json: { 
        success: true, 
        message: "Mot de passe vérifié" 
      }
    else
      render json: { 
        success: false, 
        error: "Mot de passe incorrect" 
      }, status: :unauthorized
    end
  end
  
  # POST /deletion_verifications/log_deletion
  def log_deletion
    entity_type = params[:entity_type]
    entity_name = params[:entity_name]
    entity_id = params[:entity_id]
    
    # Log deletion for audit trail
    Rails.logger.info("DELETION AUDIT: User #{current_user.email} (ID: #{current_user.id}) deleted #{entity_type} '#{entity_name}' (ID: #{entity_id}) at #{Time.current} from IP #{request.remote_ip}")
    
    # TODO: Future enhancement - Create deletion_logs table and store in database
    # This would allow for:
    # - Viewing deletion history in admin interface  
    # - Generating audit reports
    # - Compliance tracking
    #
    # Example implementation:
    # DeletionLog.create!(
    #   user: current_user,
    #   entity_type: entity_type,
    #   entity_name: entity_name,
    #   entity_id: entity_id,
    #   ip_address: request.remote_ip,
    #   user_agent: request.user_agent,
    #   deleted_at: Time.current
    # )
    
    render json: { success: true }
  rescue => e
    Rails.logger.error("DELETION LOG ERROR: #{e.message}")
    render json: { 
      success: false, 
      error: "Erreur lors de l'enregistrement" 
    }, status: :internal_server_error
  end
end
