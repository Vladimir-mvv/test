class DatafilesController < ApplicationController
 
  before_filter :require_authentication, :only=>[:new, :create, :index, :change, :showOther,:allUsers]

  def new
    @user = User.find(params[:user_id])
  end
  
  def create
    @user = User.find(params[:user_id])

      name =  params[:upload]['datafile'].original_filename
      file_ext = File.extname(name)
      arr_types = Array['.doc','.rtf','.ppt','.pps']

    if (arr_types.include?(file_ext))
      directory = "public/data"
      fpath = File.join(directory, name)
      ftype =  params[:upload]['datafile'].content_type
      fsize =  params[:upload]['datafile'].size
      begin
        find_fl = @user.datafiles.find_by_file_name(name)
        find_fl.update_attributes(:file_name => name,:file_path =>fpath,:file_type =>ftype,:file_size =>fsize,:file_share =>false)
      rescue
        @user.datafiles << Datafile.new(:file_name => name,:file_path =>fpath,:file_type =>ftype,:file_size =>fsize,:file_share =>false)
      end
      File.open(fpath, "wb") { |f| f.write(params[:upload]['datafile'].read) }
      flash[:notice] = "Файл загружен"
    else
      flash[:notice] = "Файл не загружен"
    end
    redirect_to new_user_datafile_path(@user)
  end

  def index
    @user = User.find(params[:user_id])
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = @user.datafiles.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
#      @fileslist = Datafile.find_all_by_user_id(session[:id], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = @user.datafiles.find(:all, :order => "id asc")
#      @fileslist = Datafile.find_all_by_user_id(session[:id], :order => "id asc")
    end
    render :action => "index"
  end

  def change
    if request.post?
      @user = User.find(params[:user_id])
      access_ids = params[:access_id].collect {|id| id.to_i} if params[:access_id]
      delete_ids = params[:deleteFiles].collect {|id| id.to_i} if params[:deleteFiles]
      if access_ids
        flash[:notice] = "Files successfully updated"
        access_ids.each do |id|
          sf = @user.datafiles.find(id)
          if sf.file_share
            sf.file_share = false
          else
            sf.file_share = true
          end
          sf.save
        end
      end
      if delete_ids
        flash[:notice] = "Files successfully deleted"
        Datafile.destroy(delete_ids)
      end
      flash[:notice] = "Files successfully updated and deleted" if access_ids && delete_ids
      flash[:notice] = ""  if !access_ids && !delete_ids

    end
    redirect_to user_datafiles_url(@user)
  end

  def allUsers
    @user = User.find(params[:user_id])
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = Datafile.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = Datafile.find(:all, :order => "user_id asc")
    end
    render :action => "allUsers"
  end
 
  def showOther
    @user = User.find(params[:user_id])
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = Datafile.find(:all, :conditions =>["file_share = ? AND user_id <> ?", true, params[:user_id]], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = Datafile.find(:all, :conditions =>["file_share = ? AND user_id <> ?", true, params[:user_id]], :order => "user_id asc")
    end
    render :action => "showOther"

  end
end
