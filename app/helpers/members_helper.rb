module MembersHelper
  def ban_status(user)
    if user.access_locked?
      "Activate"
    else
      "Deactivate"
    end
  end
end

