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
    @query = params[:q]
    
    if @query.present?
      search_term = "%#{@query}%"
      @contracts = Contract.where("title LIKE ? OR contract_object LIKE ?", 
                                  search_term, search_term)
                          .order(created_at: :desc)
    else
      @contracts = Contract.order(created_at: :desc)
    end
  end

  def equipment
    @query = params[:q]
    
    if @query.present?
      search_term = "%#{@query}%"
      @equipment = Equipment.where("name LIKE ? OR manufacturer LIKE ? OR model LIKE ?", 
                                   search_term, search_term, search_term)
                           .order(created_at: :desc)
    else
      @equipment = Equipment.order(created_at: :desc)
    end
  end

  def sites
    @query = params[:q]
    
    if @query.present?
      search_term = "%#{@query}%"
      @sites = Site.where("name LIKE ? OR city LIKE ? OR address LIKE ?", 
                          search_term, search_term, search_term)
                   .order(created_at: :desc)
    else
      @sites = Site.order(created_at: :desc)
    end
  end

  def organizations
    @query = params[:q]
    
    if @query.present?
      search_term = "%#{@query}%"
      @organizations = Organization.where("name LIKE ? OR headquarters_address LIKE ?", 
                                         search_term, search_term)
                                  .order(created_at: :desc)
    else
      @organizations = Organization.order(created_at: :desc)
    end
  end

  def contacts
    @query = params[:q]
    
    if @query.present?
      search_term = "%#{@query}%"
      @contacts = Contact.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR phone LIKE ?", 
                               search_term, search_term, search_term, search_term)
                        .order(created_at: :desc)
    else
      @contacts = Contact.order(created_at: :desc)
    end
  end
end
