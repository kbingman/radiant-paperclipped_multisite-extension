# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedMultiSiteExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/paperclip_multisite"
  
  # define_routes do |map|
  #   map.connect 'admin/paperclip_multisite/:action', :controller => 'admin/paperclip_multisite'
  # end
  
  def activate
    Asset.send :include, PaperclippedMultiSite::AssetExtensions
    Site.send :include, PaperclippedMultiSite::SiteExtensions
    AssetsController.send :include, PaperclippedMultiSite::AssetsControllerExtensions
    
    # admin.tabs.add "Paperclip Multisite", "/admin/paperclip_multisite", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Paperclip Multisite"
  end
  
end