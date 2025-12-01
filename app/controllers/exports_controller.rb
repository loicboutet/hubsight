class ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_portfolio_manager!

  def contracts
    organization = current_user.organization

    # Extract filter parameters from request
    filter_params = {
      search: params[:search],
      site: params[:site],
      type: params[:type],
      family: params[:family],
      subfamily: params[:subfamily],
      provider: params[:provider],
      status: params[:status],
      sort: params[:sort],
      direction: params[:direction]
    }

    # Get column visibility preferences from session
    visible_columns = session[:contract_columns] || default_contract_columns

    # Generate Excel file using service class
    exporter = ContractListExporter.new(organization, filter_params, visible_columns)
    excel_data = exporter.generate

    # Send file to user
    filename = "contrats_#{organization.name.parameterize}_#{Date.today.strftime('%Y%m%d')}.xlsx"
    
    send_data excel_data,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  rescue StandardError => e
    Rails.logger.error "Contracts export error: #{e.message}"
    redirect_to contracts_path, alert: "Erreur lors de l'export: #{e.message}"
  end

  def equipment
    organization = current_user.organization

    # Generate Excel file using service class
    exporter = EquipmentListExporter.new(organization)
    excel_data = exporter.generate

    # Send file to user
    filename = "equipements_#{organization.name.parameterize}_#{Date.today.strftime('%Y%m%d')}.xlsx"
    
    send_data excel_data,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  rescue StandardError => e
    Rails.logger.error "Equipment export error: #{e.message}"
    redirect_to equipment_index_path, alert: "Erreur lors de l'export: #{e.message}"
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

  def default_contract_columns
    %w[
      contract_number title contractor_organization_name
      contract_type purchase_subfamily
      annual_amount_ht execution_start_date end_date
      status
    ]
  end
end
