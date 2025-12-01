module Api
  class EquipmentTypesController < ApplicationController
    # GET /api/equipment_types/autocomplete
    # Returns equipment types for autocomplete search
    # Parameters:
    #   - query: search term (searches code, name, function, omniclass)
    #   - technical_lot: optional filter by technical lot trigram (CVC, ELE, PLO, etc.)
    #   - function: optional filter by function
    def autocomplete
      @equipment_types = EquipmentType.active.ordered
      
      # Apply search filter
      @equipment_types = @equipment_types.search(params[:query]) if params[:query].present?
      
      # Apply technical lot filter
      @equipment_types = @equipment_types.by_technical_lot(params[:technical_lot]) if params[:technical_lot].present?
      
      # Apply function filter
      @equipment_types = @equipment_types.by_function(params[:function]) if params[:function].present?
      
      # Limit results
      @equipment_types = @equipment_types.limit(50)
      
      # Format response
      render json: @equipment_types.map { |et| format_equipment_type(et) }
    end
    
    private
    
    def format_equipment_type(equipment_type)
      {
        id: equipment_type.id,
        code: equipment_type.code,
        name: equipment_type.equipment_type_name,
        display_name: equipment_type.display_name,
        technical_lot_trigram: equipment_type.technical_lot_trigram,
        technical_lot: equipment_type.technical_lot,
        technical_lot_name: equipment_type.technical_lot_name,
        purchase_subfamily: equipment_type.purchase_subfamily,
        function: equipment_type.function,
        omniclass_number: equipment_type.omniclass_number,
        omniclass_title: equipment_type.omniclass_title,
        characteristics: equipment_type.characteristics,
        lot_badge_color: equipment_type.lot_badge_color
      }
    end
  end
end
