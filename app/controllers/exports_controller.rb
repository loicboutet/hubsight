class ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_portfolio_manager!

  def contracts
    # Handle admin vs portfolio manager
    # Admin users don't have an organization, so we need to handle them differently
    if current_user.admin?
      organization = nil
      organization_name = "tous_contrats"
    else
      organization = current_user.organization
      unless organization
        redirect_to contracts_path, alert: "Aucune organisation associée à votre compte."
        return
      end
      organization_name = organization.name.parameterize
    end

    # Extract filter parameters from request (including advanced filters)
    filter_params = {
      search: params[:search],
      site: params[:site],
      building: params[:building],
      type: params[:type],
      family: params[:family],
      subfamily: params[:subfamily],
      provider: params[:provider],
      renewal: params[:renewal],
      status: params[:status],
      signature_date_from: params[:signature_date_from],
      signature_date_to: params[:signature_date_to],
      start_date_from: params[:start_date_from],
      start_date_to: params[:start_date_to],
      end_date_from: params[:end_date_from],
      end_date_to: params[:end_date_to],
      amount_ht_min: params[:amount_ht_min],
      amount_ht_max: params[:amount_ht_max],
      amount_ttc_min: params[:amount_ttc_min],
      amount_ttc_max: params[:amount_ttc_max],
      sort: params[:sort],
      direction: params[:direction]
    }

    # Get column visibility preferences from session
    visible_columns = session[:contract_columns] || default_contract_columns

    # Generate Excel file using service class
    exporter = ContractListExporter.new(organization, filter_params, visible_columns)
    excel_data = exporter.generate

    # Send file to user
    filename = "contrats_#{organization_name}_#{Date.today.strftime('%Y%m%d')}.xlsx"
    
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
    export_format = params[:export_format] || 'hierarchical'
    
    # Get organization - for admins, get first org or handle differently
    organization = if current_user.admin?
                     # Admin users might not have an organization, use first org or all sites
                     Organization.first
                   else
                     current_user.organization
                   end
    
    unless organization
      redirect_to sites_path, alert: "Aucune organisation trouvée pour l'export."
      return
    end

    # Generate Excel file using service class
    exporter = SitesStructureExporter.new(organization, export_format)
    excel_data = exporter.generate

    # Send file to user
    format_label = export_format == 'sheets' ? 'multi_feuilles' : 'hierarchique'
    filename = "structure_sites_#{format_label}_#{organization.name.parameterize}_#{Date.today.strftime('%Y%m%d')}.xlsx"
    
    send_data excel_data,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  rescue StandardError => e
    Rails.logger.error "Sites export error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    redirect_to sites_path, alert: "Erreur lors de l'export: #{e.message}"
  end

  private

  def authorize_portfolio_manager!
    unless current_user.portfolio_manager? || current_user.admin?
      redirect_to root_path, alert: "Accès non autorisé. Seuls les gestionnaires de portefeuille et administrateurs peuvent exporter des données."
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
