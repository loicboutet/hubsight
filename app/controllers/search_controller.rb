class SearchController < ApplicationController
  def index
    @query = params[:q]
    
    if @query.present?
      # Search across all models (case-insensitive for SQLite)
      search_term = "%#{@query}%"
      
      @sites = Site.where("name LIKE ? OR city LIKE ? OR address LIKE ?", 
                          search_term, search_term, search_term)
                   .order(created_at: :desc).limit(6)
      
      @contracts = Contract.where("title LIKE ? OR contract_object LIKE ?", 
                                  search_term, search_term)
                          .order(created_at: :desc).limit(5)
      
      @equipment = Equipment.where("name LIKE ? OR manufacturer LIKE ? OR model LIKE ?", 
                                   search_term, search_term, search_term)
                           .order(created_at: :desc).limit(6)
      
      @organizations = Organization.where("name LIKE ? OR headquarters_address LIKE ?", 
                                         search_term, search_term)
                                  .order(created_at: :desc).limit(8)
    else
      # Show recent items when no search query
      @sites = Site.order(created_at: :desc).limit(6)
      @contracts = Contract.order(created_at: :desc).limit(5)
      @equipment = Equipment.order(created_at: :desc).limit(6)
      @organizations = Organization.order(created_at: :desc).limit(8)
    end
  end

  def contracts
    # Renders search/contracts.html.erb
  end

  def equipment
    # Renders search/equipment.html.erb
  end

  def sites
    # Renders search/sites.html.erb
  end

  def organizations
    # Renders search/organizations.html.erb
  end
end
