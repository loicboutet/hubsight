class ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_portfolio_manager!

  def contracts
    # Handle contracts export
    send_data "contracts export", filename: "contracts.csv"
  end

  def equipment
    # Handle equipment export
    send_data "equipment export", filename: "equipment.csv"
  end

  def sites
    # Determine export format (hierarchical or sheets)
    format = params[:format] || 'hierarchical'
    organization = current_user.organization

    # Generate Excel file using service class
    exporter = SitesStructureExporter.new(organization, format)
    excel_data = exporter.generate

    # Send file to user
    filename = "structure_sites_#{organization.name.parameterize}_#{Date.today.strftime('%Y%m%d')}.xlsx"
    
    send_data excel_data,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  rescue StandardError => e
    Rails.logger.error "Sites export error: #{e.message}"
    redirect_to sites_path, alert: "Erreur lors de l'export: #{e.message}"
  end

  private

  def authorize_portfolio_manager!
    unless current_user.portfolio_manager? || current_user.admin?
      redirect_to root_path, alert: "Accès non autorisé. Seuls les gestionnaires de portefeuille peuvent exporter des données."
    end
  end
end
