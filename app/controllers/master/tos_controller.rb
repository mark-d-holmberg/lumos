class Master::TosController < MasterController

  before_action :set_tos, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @tos.update(safe_params)
      redirect_to tos_path, notice: 'Terms and Conditions were successfully updated.'
    else
      render :edit
    end
  end


  private

  def set_tos
    @tos = Tos.all.first!
  end

  def safe_params
    params.require(:tos).permit(:content)
  end

end
