class DrugsController < ApplicationController
  before_action :set_drug, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :validate_authorization
  before_action :allow_iframe
  authorize_resource

  def allow_iframe
    response.headers.delete('X-Frame-Options')

  end

  # GET /drugs
  def index
    @drugs = Drug.all
  end

  def home

  end

  # GET /drugs/1
  def show
  end

  # GET /drugs/new
  def new
    @drug = Drug.new
  end

  # GET /drugs/1/edit
  def edit
  end

  # POST /drugs
  def create

    @drug = Drug.where(drug_params).first_or_create

    if params[:drug][:picture]
      drug = @drug
      file = params[:drug][:picture]
      ext = File.extname(file.original_filename)
      name = @drug.id.to_s + ext
      directory = "public/images/upload"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:drug][:picture].read) }
      @drug.img = name
    end

    if @drug.save
      redirect_to :root, notice: 'Drug was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /drugs/1
  def update
    if @drug.update(drug_params)
      if params[:drug][:picture]
        drug = @drug
        file = params[:drug][:picture]
        ext = File.extname(file.original_filename)
        name = @drug.id.to_s + ext
        directory = "public/images/upload"
        path = File.join(directory, name)
        File.open(path, "wb") { |f| f.write(params[:drug][:picture].read) }
        @drug.img = name
        @drug.save
      end
      redirect_to :action => :index, notice: 'Drug was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /drugs/1
  def destroy
    @drug.destroy
    redirect_to :action => :index
  end

  def search
    if params[:search]
      key = params[:search]
      # @drugs = Drug.where(product_type: {'$regex' => "/" + key + "/i"})
      reg = "/" + key + "/i"
      debugger
      @drugs = Drug.where(product_type: {'$regex' => reg})
    end
  end

  def upload_pic
    if params[:id]
      drug = Drug.find(params[:id])
      file = params[:picture]
      ext = File.extname(file.original_filename)
      name = drug.id.to_s + ext
      directory = "public/images/upload"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:picture].read) }
      drug.img = name
      drug.save!
      flash[:notice] = "File uploaded"
    end
    redirect_to :action => :index
  end


  def print_xls
    if current_user.admin
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      format = Spreadsheet::Format.new :weight => :bold

      # report header
      sheet.row(0).push("brand_name", "generic_name", "company_name", "product_type", "quantity", "price", "dose")
      sheet.row(0).default_format = format
      # populate rows
      r=1
      Drug.all.each do |item|
        sheet.row(r).push(item.brand_name, item.generic_name, item.company_name, item.product_type, item.quantity, item.price, item.dose)
        r+=1
      end

      data = StringIO.new '';
      book.write data;
      send_data(data.string, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/vnd.ms-excel',
        :filename => 'drugs.xls'
      })
    end
  end

  private

    def validate_authorization
      authorize! :manage, Drug
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_drug
      @drug = Drug.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def drug_params
      params.require(:drug).permit(:brand_name, :generic_name, :company_name, :price, :dose, :quantity, :product_type)
    end
end
