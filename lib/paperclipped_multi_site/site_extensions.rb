module PaperclippedMultiSite::SiteExtensions
  def self.included(base)
    base.has_many :assets
  end
end