module Admin::LogsHelper
  def format_log_line(line)
    # Use white text for all log lines for better readability
    "<span class='text-white'>#{ERB::Util.html_escape(line)}</span>".html_safe
  end
end
