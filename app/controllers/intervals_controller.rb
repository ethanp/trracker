class IntervalsController < ApplicationController
  before_action :set_interval, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /intervals
  # GET /intervals.json
  def index
    @intervals = current_user.intervals
  end

  # GET /intervals/1
  # GET /intervals/1.json
  def show
    unless current_user.intervals.to_ids.include? Integer(params[:id])
      redirect_to homepage_path
    end
  end

  # GET /intervals/new
  def new
    @interval = Interval.new
    @interval.task_id = params[:task_id]
  end

  # GET /intervals/1/edit
  def edit
  end

  # POST /intervals
  # POST /intervals.json
  def create
    my_params = parse_times(interval_params)
    @interval = Interval.new(my_params)
    @interval.task_id = params[:task_id]

    respond_to do |format|
      if not (my_params[:start].nil? or my_params[:end].nil?) and @interval.save
        format.html { redirect_to @interval.task, alert: 'Interval was successfully created.' }
        format.json { render :show, status: :created, location: @interval }
      else
        format.html { redirect_to @interval.task, notice: 'Interval was invalid' }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_ajax
    puts params
    start_end = params[:interval].split.map { |milli|
      DateTime.strptime((milli.to_f / 1000).to_s, '%s')
    }
    @interval = Interval.new(start: start_end.first,
                             end: start_end.last,
                             task_id: params[:task_id])
      if @interval.save
      # TODO what this should actually do is respond with the new interval entry for the table
        render @interval
      else
        redirect_to(Task.find(params[:task_id]), notice: 'Problem creating interval.')
      end
    end

  # PATCH/PUT /intervals/1
  # PATCH/PUT /intervals/1.json
  def update
    respond_to do |format|
      if @interval.update(interval_params)
        format.html { redirect_to @interval.task, notice: 'Interval was successfully updated.' }
        format.json { render :show, status: :ok, location: @interval }
      else
        format.html { render :edit }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intervals/1
  # DELETE /intervals/1.json
  def destroy
    task = @interval.task
    @interval.destroy
    respond_to do |format|
      format.html { redirect_to task_url(task), notice: 'Interval was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interval
      @interval = Interval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interval_params
      params.require(:interval).permit(:start, :end, :task_id)
    end


    def parse_times(p)
      my_params = p
      my_params[:start] = parse_datetime_form(p[:start])
      my_params[:end] = parse_datetime_form(p[:end])
      my_params
    end
end
