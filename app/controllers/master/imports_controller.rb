class Master::ImportsController < MasterController

  def schools
    if request.post?
      result = Import.import_schools(safe_params.try(:[], :file))
      if result[:success]
        flash[:notice] = "Successfully imported stuff, count: #{result.try(:[], :count)}"
      else
        flash[:error] = "Failed to import: #{result.try(:[], :message)}"
      end
      redirect_to schools_imports_url
    else
      # GET stuff here
    end
  end


  private

  def safe_params
    safe_attributes = [:file]
    params.require(:imports).permit(safe_attributes)
  end

end
