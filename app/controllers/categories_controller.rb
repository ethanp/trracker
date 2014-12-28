class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /categories
  # GET /categories.json
  def index
    @categories = current_user.categories

    # this is for better row-by-row aligned displaying of the categories
    # this turns [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] => [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9]]
    # so that each row contains 4 categories
    @category_rows = @categories.each_slice(4).to_a
    @page_title = "Categories"
  end


  def time_per_task_per_day
    # puts "@category.time_per_task_per_day: #{@category.time_per_task_per_day}"
    respond_to do |format|
      # format.html  # time_per_task_per_day.html.erb (doesn't exist)
      format.json { render json: @category.time_per_day }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    unless current_user.categories.to_ids.include? Integer(params[:id])
      redirect_to homepage_path
    end
    @page_title = @category.name
  end

  # GET /categories/new
  def new
    @category = Category.new
    @category.user = current_user
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    @category.user = current_user
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(parse_dates(category_params))
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :description, :start_date, :end_date)
    end

    def parse_dates(p)
      my_params = p
      my_params[:start_date] = parse_datetime_form(p[:start_date])
      my_params[:end_date] = parse_datetime_form(p[:end_date])
      my_params
    end
end
