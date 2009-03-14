require File.dirname(__FILE__) + '/../spec_helper'

describe Asset do
  dataset :assets
  
  before(:each) do
    Page.current_site = sites(:test)
    @asset = assets(:picture)
  end

  it "should have a site" do
    Asset.reflect_on_association(:site).should_not be_nil
    @asset.respond_to?(:site).should be_true
    @asset.site.should == sites(:test)
  end
  
  it "should get the current site automatically on validation" do
    a = Asset.new
    a.valid?
    a.site.should == sites(:test)
  end
  
  it "should not be able to retrieve an asset belonging to another site" do
    lambda{ a = assets(:other) }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should be able to retrieve an asset belonging to the current site" do
    Page.current_site = sites(:elsewhere)
    lambda{ a = assets(:other) }.should_not raise_error(ActiveRecord::RecordNotFound)
  end

end
