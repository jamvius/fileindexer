class StatusTasksController < ApplicationController
  # GET /status_tasks
  # GET /status_tasks.json
  def index
    @status_tasks = StatusTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @status_tasks }
    end
  end

  # GET /status_tasks/1
  # GET /status_tasks/1.json
  def show
    @status_task = StatusTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status_task }
    end
  end

  # GET /status_tasks/new
  # GET /status_tasks/new.json
  def new
    @status_task = StatusTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status_task }
    end
  end

  # GET /status_tasks/1/edit
  def edit
    @status_task = StatusTask.find(params[:id])
  end

  # POST /status_tasks
  # POST /status_tasks.json
  def create
    @status_task = StatusTask.new(params[:status_task])

    respond_to do |format|
      if @status_task.save
        format.html { redirect_to @status_task, notice: 'Status task was successfully created.' }
        format.json { render json: @status_task, status: :created, location: @status_task }
      else
        format.html { render action: "new" }
        format.json { render json: @status_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /status_tasks/1
  # PUT /status_tasks/1.json
  def update
    @status_task = StatusTask.find(params[:id])

    respond_to do |format|
      if @status_task.update_attributes(params[:status_task])
        format.html { redirect_to @status_task, notice: 'Status task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_tasks/1
  # DELETE /status_tasks/1.json
  def destroy
    @status_task = StatusTask.find(params[:id])
    @status_task.destroy

    respond_to do |format|
      format.html { redirect_to status_tasks_url }
      format.json { head :no_content }
    end
  end
end
