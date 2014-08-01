module ApplicationHelper
  def pressing_duedate(task)
    if not task.duedate.nil?
      due = DateTime.parse(task.duedate.to_s)
      distance = (due - DateTime.now).to_f
      case distance
        when 0..3
          "danger"
        when 3..7
          "warning"
      end
    end
  end
end
