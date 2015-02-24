module UsersHelper
  def selected_message(sub)
    if sub.message.blank?
      ""
    else
      sub.message.id
    end
  end


end
