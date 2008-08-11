class AddSiteIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :site_id, :integer
  end
  
  def self.down
    remove_column :assets, :site_id
  end
end