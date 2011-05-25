class Datafile < ActiveRecord::Base
 
  belongs_to :user, :foreign_key => "user_id"

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
