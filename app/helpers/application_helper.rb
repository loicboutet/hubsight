module ApplicationHelper
  # Check if the current path matches the given path or starts with it
  # Used for highlighting active menu items in navigation
  def active_menu_item?(path)
    current_path = request.path
    
    # Exact match
    return true if current_path == path
    
    # Check if current path starts with the given path (for sub-pages)
    # But avoid matching "/contracts" when on "/contract_families"
    if path != '/' && current_path.start_with?(path)
      # Make sure the next character is a slash or end of string
      next_char_index = path.length
      return true if current_path[next_char_index].nil? || current_path[next_char_index] == '/'
    end
    
    false
  end
end
