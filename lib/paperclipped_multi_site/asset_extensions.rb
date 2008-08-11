module PaperclippedMultiSite::AssetExtensions
  
  def self.included(base)
    base.belongs_to :site
  end
  
end