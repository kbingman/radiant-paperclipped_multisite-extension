class AssetSitesDataset < Dataset::Base

  def load
    create_record Site, :test, :name => 'Test Site', :domain => 'test', :base_domain => 'test.host', :position => 1, :mail_from_name => 'test sender', :mail_from_address => 'sender@spanner.org'
    create_record Site, :elsewhere, :name => 'Another Site', :domain => 'other', :base_domain => 'other.host', :position => 2, :mail_from_name => 'test sender', :mail_from_address => 'sender@spanner.org'
    Page.current_site = sites(:test)
  end
 
end