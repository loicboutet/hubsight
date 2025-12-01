module Admin::LogsHelper
  def format_log_line(line)
    # Use inline style to ensure white text is visible
    "<span style='color: white !important;'>#{ERB::Util.html_escape(line)}</span>".html_safe
  end
end
