class Master::ReportsController < MasterController

  def index
  end

  def pending_impressions
    @impressions = Impression.ordered.page(params[:page])
  end

end
