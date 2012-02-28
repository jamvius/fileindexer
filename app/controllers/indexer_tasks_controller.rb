require "digest/md5"

class IndexerTasksController < ApplicationController
  # GET /indexer_tasks
  # GET /indexer_tasks.json
  def index
    @indexer_tasks = IndexerTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @indexer_tasks }
    end
  end

  # GET /indexer_tasks/1
  # GET /indexer_tasks/1.json
  def show
    @indexer_task = IndexerTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @indexer_task }
    end
  end

  # GET /indexer_tasks/new
  # GET /indexer_tasks/new.json
  def new
    @indexer_task = IndexerTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @indexer_task }
    end
  end

  # GET /indexer_tasks/1/edit
  def edit
    @indexer_task = IndexerTask.find(params[:id])
  end

  # POST /indexer_tasks
  # POST /indexer_tasks.json
  def create
    @indexer_task = IndexerTask.new(params[:indexer_task])

    respond_to do |format|
      if @indexer_task.save
        format.html { redirect_to @indexer_task, notice: 'Indexer task was successfully created.' }
        format.json { render json: @indexer_task, status: :created, location: @indexer_task }
      else
        format.html { render action: "new" }
        format.json { render json: @indexer_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /indexer_tasks/1
  # PUT /indexer_tasks/1.json
  def update
    @indexer_task = IndexerTask.find(params[:id])

    respond_to do |format|
      if @indexer_task.update_attributes(params[:indexer_task])
        format.html { redirect_to @indexer_task, notice: 'Indexer task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @indexer_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexer_tasks/1
  # DELETE /indexer_tasks/1.json
  def destroy
    @indexer_task = IndexerTask.find(params[:id])
    @indexer_task.destroy

    respond_to do |format|
      format.html { redirect_to indexer_tasks_url }
      format.json { head :no_content }
    end
  end

  def analyze
    @indexer_task = IndexerTask.find(params[:id])
    @indexer_task.run
  end

end
