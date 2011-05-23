class CreateDatafiles < ActiveRecord::Migration
  def self.up
    create_table :datafiles do |t|
      t.integer :user_id
      t.string :file_name
      t.string :file_path
      t.boolean :file_share
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :datafiles
  end
end
