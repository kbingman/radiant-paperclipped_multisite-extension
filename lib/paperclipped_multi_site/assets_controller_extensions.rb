module PaperclippedMultiSite::AssetsControllerExtensions
  
  def self.included(base)
    base.class_eval {
      make_resourceful do 
        actions :all
       
        response_for :index do |format|
          format.html { render }
          format.js {
            if params[:asset_page]
              @asset_page = Page.find(params[:asset_page])
              render :partial => 'assets/search_results.html.haml', :layout => false
            else
              render :partial => 'assets/asset_table.html.haml', :layout => false
            end
          }
        end
        
        after :create do
          if params[:page]
            @page = Page.find(params[:page])
            @asset.pages << @page
          end
          @asset.site = current_user.site if current_user.site
        end
        
        after :update do
          @asset.site = current_user.site if current_user.site
        end
        
        response_for :update do |format|
          format.html { 
            flash[:notice] = "Asset successfully updated."
            redirect_to(params[:continue] ? edit_asset_path(@asset) : assets_path) 
          }
        end
        response_for :create do |format|
          format.html { 
            flash[:notice] = "Asset successfully uploaded."
            redirect_to(@page ? page_edit_url(@page) : (params[:continue] ? edit_asset_path(@asset) : assets_path)) 
          }
        end

      end
      
      protected

        def current_objects
          term = params['search'].downcase + '%' if params['search']
          @mark_term = params['search']
          site_id = current_user.site

          if @mark_term
            condition = [ 'LOWER(title) LIKE ? or LOWER(caption) LIKE ? or LOWER(asset_file_name) LIKE ? (and site_id = ? OR site_id IS NULL)', '%' + term, '%' + term, '%' + term, @site.id  ]
          else
            condition = [ "site_id = ? OR site_id IS NULL", site_id ] if current_user.site
          end
          Asset.paginate(:all, :conditions => condition, :order => 'created_at DESC', :page => params[:page], :per_page => 10)
        end
    }
  end
   
end
