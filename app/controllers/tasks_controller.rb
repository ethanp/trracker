class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    unless current_user.tasks.to_ids.include? Integer(params[:id])
      redirect_to homepage_path
    end
    @interval = Interval.new
    @subtask = Subtask.new
  end

  def show_heatmap_data
    puts Task.find(params[:task_id]).heatmap_hash_array.as_json
    respond_to do |format|
      format.html # show_heatmap_data.html.erb (doesn't exist)
      format.json { render json: Task.find(params[:task_id]).heatmap_hash_array }
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.category_id = params[:category_id]
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    # convert the text datetime to a Rails-friendly datetime
    # & set the timezone of the duedate to the current timezone
    my_params = parse_duedate(task_params)
    @task = Task.new(my_params)
    @task.category_id = params[:category_id]

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @task = Task.find(params[:task_id])
    @task.complete = !@task.complete
    @task.save
    redirect_to @task
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      my_params = parse_duedate(task_params)
      if @task.update(my_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    cat = @task.category
    @task.destroy
    respond_to do |format|
      format.html { redirect_to category_url(cat), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :complete, :duedate, :category_id, :priority)
    end

    def parse_duedate(p)
      my_params = p
      my_params[:duedate] = parse_datetime_form(p[:duedate])
      my_params
    end
end
