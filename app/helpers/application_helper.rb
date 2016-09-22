module ApplicationHelper
  def active_state_for_controller(controller)
    is_active?(controller) ? 'active' : ''
  end

  def is_active?(controller_name)
    params[:controller] == controller_name
  end
end
