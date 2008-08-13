module PaperclippedMultiSite::AssetsControllerExtensions
  
  def self.included(base)
    base.class_eval {
      before_filter :set_site
      
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
          @asset.site = @site
          @asset.save
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
      
        def set_site
          @site = Site.find_for_host(request.host)
        end

        def current_objects
          unless params['search'].blank?
            term = params['search'].downcase

            search_cond_sql = []
            cond_params = {}
          
            search_cond_sql << 'LOWER(asset_file_name) LIKE (:term)'
            search_cond_sql << 'LOWER(title) LIKE (:term)'
            search_cond_sql << 'LOWER(caption) LIKE (:term)'
            search_cond = search_cond_sql.join(" or ")
            search_site_sql = ['site_id = (:site_id)']
          
            cond_sql = "#{search_site_sql} and (#{search_cond})"
          
            cond_params[:term] = "%#{term}%"
            cond_params[:site_id] = @site.id
          
            @conditions = [cond_sql, cond_params]
          else
            @conditions = ['site_id = ?', @site.id]
          end
          
          @file_types = params[:filter].blank? ? [] : params[:filter].keys

          if not @file_types.empty?
            Asset.paginate_by_content_types(@file_types, :all, :conditions => @conditions, :order => 'created_at DESC', 
              :page => params[:page], :per_page => 10, :total_entries => count_by_conditions)
          else
            Asset.paginate(:all, :conditions => @conditions, :order => 'created_at DESC', :page => params[:page], :per_page => 10)
          end
        end

        def count_by_conditions
          type_conditions = @file_types.blank? ? nil : Asset.types_to_conditions(@file_types.dup).join(" OR ")
          @count_by_conditions ||= @conditions.empty? ? Asset.count(:all, :conditions => type_conditions) : Asset.count(:all, :conditions => @conditions)
        end
    }
  end
   
end
