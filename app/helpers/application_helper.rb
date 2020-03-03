module ApplicationHelper
  def show_table_row(label,data)
    content_tag :tr do
      concat(show_label(label) + show_data(data))
    end
  end

  def show_label(label)
    content_tag :th, label
  end

  def show_data(data)
    content_tag :td, data
  end

  def inspect_session
    inspect = {}
    session.keys.each do |k|
      inspect[k] = session[k]
    end
    inspect
  end
  alias session_inspect inspect_session


end
