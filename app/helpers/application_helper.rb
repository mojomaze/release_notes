module ApplicationHelper
  
  def get_mantis_status(code)
    case code
    when 80
      return 'Resolved'
    when 90
      return 'Closed'
    else
      retrun code.to_s
    end
  end
  
  def get_mantis_resolution(code)
    case code
    when 20
      return 'Fixed'
    else
      return code.to_s
    end
  end
  
  def set_nav(nav)
    return ' current' if nav == controller.controller_name
  end
  
end
