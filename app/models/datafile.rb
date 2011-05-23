class Datafile < ActiveRecord::Base
  def self.save(upload, user_id)
      name =  upload['datafile'].original_filename
      file_ext = File.extname(name)
      find_f = Datafile.find_by_user_id_and_file_name
      arr_types = Array['.doc','.rtf','.ppt','.pps']
      return if !(arr_types.include?(file_ext))
    begin
      directory = "public/data"
      # create the file path
      fpath = File.join(directory, name)
      ftype =  upload['datafile'].content_type
      fsize =  upload['datafile'].size
      c = Datafile.find_by_name_and_user_id(name, user_id)
      c.update_attributes(:user_id =>user_id,:file_name => name,:file_path =>fpath,:file_type =>ftype,:file_size =>fsize,:file_share =>false)
    rescue
      new_f = Datafile.new do |f|
        f.user_id = user_id
        f.file_name    = name
        f.file_path    = fpath
        f.file_type    = ftype
        f.file_size    = fsize
        f.file_share   = false
        f.save
      end
    end
    File.open(fpath, "wb") { |f| f.write(upload['datafile'].read) }
  end

  def self.destroy(delete_ids)
    if delete_ids
      delete_ids.each do |id|
        c = find(id)
        directory = "#{RAILS_ROOT}"
        path = File.join(directory, c.file_path)
        c.destroy
        if !(File.directory?("#{path}"))
          File.delete("#{path}") if File.exist?("#{path}")
        end
      end
    end
  end

end
