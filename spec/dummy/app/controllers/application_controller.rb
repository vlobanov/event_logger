class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protect_event_logger do
    $before_filter_block_counter ||= 0
    $before_filter_block_counter += 1
  end

  protect_event_logger :method_protection

  def method_protection
    $before_filter_method_counter ||= 0
    $before_filter_method_counter += 1
  end
end
