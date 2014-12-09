module TasksHelper
  # produces the Bootstrap 3 css classes for items in the /tasks list
  def index_css_class task
    if task.turned_in
      if task.complete
        nil
      else
        'warning'
      end
    elsif task.complete
      'success'
    elsif task.duedate.nil?
      nil
    elsif task.duedate_distance_in_days < 0
      'danger'
    else
      case task.duedate_distance_in_days
        when 0..3
          'warning'
        when 3..7
          'info'
      end
    end
  end
end
