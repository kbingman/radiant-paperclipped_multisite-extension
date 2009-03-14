# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedMultiSiteExtension < Radiant::Extension
  version "1.1"
  description "This is a little shim that scopes assets to sites. It requires the spanner fork of multi_site"
  url ""
  
  def activate
    Asset.send :is_site_scoped
    admin.assets.index.add :top, "admin/shared/site_jumper"
  end
  
end