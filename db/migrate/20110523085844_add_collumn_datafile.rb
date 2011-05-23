class AddCollumnDatafile < ActiveRecord::Migration
  def self.up
    add_column :datafiles, :file_size, :integer
  end

  def self.down
    remove_column :datafiles, :file_size
  end
end
