class Master::ProductsController < MasterController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
    @products = @products.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @products = @products.sorty_order(sort_column, sort_direction)
    else
      @products = @products.ordered
    end
    @products = @products.page(params[:page])
  end

  def show
    @campaigns = @product.campaigns.ordered.page(params[:campaigns_page])
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(safe_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(safe_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully removed.'
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def safe_params
    params.require(:product).permit(:name, :description, :price_dollars)
  end

end
