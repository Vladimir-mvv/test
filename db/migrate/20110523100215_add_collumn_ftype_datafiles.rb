class AddCollumnFtypeDatafiles < ActiveRecord::Migration
   def self.up
    add_column :datafiles, :file_type, :string
  end

  def self.down
    remove_column :datafiles, :file_type
  end
end
