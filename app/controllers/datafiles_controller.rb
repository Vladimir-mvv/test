class DatafilesController < ApplicationController
  def new
    render :controller => "datafiles", :action => "new"
  end
  def create
    @target_file = Datafile.save(params[:upload],session[:id])
    if @target_file
      flash[:notice] = "Файл загружен"
    else
      flash[:notice] = "Файл не загружен"
    end
    render :controller => "datafiles", :action => "new"
  end

  def edit
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = Datafile.find_all_by_user_id(session[:id], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = Datafile.find_all_by_user_id(session[:id], :order => "id asc")
    end
    render :controller => "datafiles", :action => "edit"
  end

  def change
    if request.post?
      access_ids = params[:access_id].collect {|id| id.to_i} if params[:access_id]
      delete_ids = params[:deleteFiles].collect {|id| id.to_i} if params[:deleteFiles]
      if access_ids
        flash[:notice] = "Files successfully updated"
        access_ids.each do |id|
          sf = Datafile.find_by_id_and_user_id(id,session[:id])
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
    redirect_to :controller => "datafiles", :action => "edit", :id => session[:id]
  end
  def index
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = Datafile.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = Datafile.find(:all, :order => "user_id asc")
    end
    render :controller => "datafiles", :action => "index"
  end
 
  def show
    
    case params[:ffield]
    when 'file_type','file_size','file_name'
      @fileslist = Datafile.find(:all, :conditions =>["file_share = ? AND user_id <> ?", true, session[:id]], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @fileslist = Datafile.find(:all, :conditions =>["file_share = ? AND user_id <> ?", true, session[:id]], :order => "user_id asc")
    end
    render :controller => "datafiles", :action => "show"

  end
end
