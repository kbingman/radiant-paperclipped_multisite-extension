class AssetsDataset < Dataset::Base
  uses :asset_sites if defined? Site

  def load
    create_asset "Picture"
    create_asset "Other", :site_id => site_id(:elsewhere)
  end
  
  helpers do
    def create_asset(title, att={})
      asset = create_record Asset, title.symbolize, asset_attributes(att.update(:title => title))
    end
    
    def asset_attributes(att={})
      title = att[:title] || "John Doe"
      symbol = title.symbolize
      attributes = { 
        :title => title,
        :caption => "this is the caption", 
        :asset_file_name => "#{title.downcase.underscore}.jpg", 
        :asset_file_size => 1024,
        :asset_content_type => "image/jpeg"
      }.merge(att)
      attributes[:site_id] ||= site_id(:test) if defined? Site
      attributes
    end

  end
end