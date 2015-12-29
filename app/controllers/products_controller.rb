class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :validate_authorization
  before_action :allow_iframe
  authorize_resource

  def allow_iframe
    response.headers.delete('X-Frame-Options')

  end

  # GET /drugs
  def index
    @products = Product.all
  end


  def other_products
    @products = Product.where(:category.ne => nil)
  end

  def home

  end

  # GET /drugs/1
  def show
  end

  # GET /drugs/new
  def new
    @product = Product.new
  end

  def new_other_product
    @product = Product.new
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /drugs/1/edit
  def edit
  end

  # POST /drugs
  def create
    picture = params[:product].delete(:picture)
    @product = Product.where(params[:product]).first_or_create

    if picture
      product = @product
      file = picture
      ext = File.extname(file.original_filename)
      name = @product.id.to_s + ext
      directory = "public/images/upload"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(picture.read) }
      @product.img = name
    end

    if @product.save
      redirect_to :root, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /drugs/1
  def update
    if @product.update(product_params)
      if params[:product][:picture]
        product = @product
        file = params[:product][:picture]
        ext = File.extname(file.original_filename)
        name = @product.id.to_s + ext
        directory = "public/images/upload"
        path = File.join(directory, name)
        File.open(path, "wb") { |f| f.write(params[:product][:picture].read) }
        @product.img = name
        @product.save
      end
      redirect_to :search
    else
      render :edit
    end
  end

  # DELETE /drugs/1
  def destroy
    @product.destroy
    redirect_to :back
  end

  def search
    debugger    
    if params[:search]
      @products = Product.full_text_search(params[:search], allow_empty_search: true)
    end
    debugger
  end

  def upload_pic
    if params[:id]
      product = Product.find(params[:id])
      file = params[:picture]
      ext = File.extname(file.original_filename)
      name = product.id.to_s + ext
      directory = "public/images/upload"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:picture].read) }
      product.img = name
      product.save!
      flash[:notice] = "File uploaded"
    end
    redirect_to :root
  end


  def print_xls
    if current_user.admin
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      format = Spreadsheet::Format.new :weight => :bold

      # report header
      sheet.row(0).push("id", "brand_name", "generic_name", "company_name", "product_type", "quantity", "price", "dose", "create_date")
      sheet.row(0).default_format = format
      # populate rows
      r=1

      Product.all.each do |item|
        sheet.row(r).push(item._id.to_s, item.brand_name, item.generic_name, item.company_name, item.product_type, item.quantity, item.price, item.dose, item.create_date)
        r+=1
      end

      data = StringIO.new '';
      book.write data;
      send_data(data.string, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/vnd.ms-excel',
        :filename => 'products.xls'
      })
    end
  end

  private

    def validate_authorization
      authorize! :manage, Product
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      # params.require(:product).permit(:brand_name, :generic_name, :company_name, :price, :dose, :quantity, :product_type)
    end
end
