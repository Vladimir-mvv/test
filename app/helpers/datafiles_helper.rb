module DatafilesHelper
  def sort_show_url (action_name, name, ffield)
    str = "#{link_to name,:action =>action_name,:ffield =>ffield, :order =>'asc'} " +
          "#{link_to 'asc',:action =>action_name,:ffield =>ffield, :order =>'asc'} "+
          "#{link_to 'desc',:action =>action_name,:ffield =>ffield, :order =>'desc'}"
  end
  def opposite_share(file_share)
    if file_share
      str = "false"
   else
      str = "true"
   end

 end
end