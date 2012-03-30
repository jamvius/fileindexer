class IndexedDirectoriesController < ApplicationController
  # GET /indexed_directories
  # GET /indexed_directories.json
  def index
    @indexed_directories = IndexedDirectory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @indexed_directories }
    end
  end

  # GET /indexed_directories/1
  # GET /indexed_directories/1.json
  def show
    @indexed_directory = IndexedDirectory.find(params[:id])
    @indexed_directory.go_to
    @new_directories = @indexed_directory.find_new_directories
    @new_files = @indexed_directory.find_new_files

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @indexed_directory }
    end
  end

  # GET /indexed_directories/new
  # GET /indexed_directories/new.json
  def new
    @indexed_directory = IndexedDirectory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @indexed_directory }
    end
  end

  # GET /indexed_directories/1/edit
  def edit
    @indexed_directory = IndexedDirectory.find(params[:id])
  end

  # POST /indexed_directories
  # POST /indexed_directories.json
  def create
    @indexed_directory = IndexedDirectory.new(params[:indexed_directory])

    respond_to do |format|
      if @indexed_directory.save
        format.html { redirect_to @indexed_directory, notice: 'Indexed directory was successfully created.' }
        format.json { render json: @indexed_directory, status: :created, location: @indexed_directory }
      else
        format.html { render action: "new" }
        format.json { render json: @indexed_directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /indexed_directories/1
  # PUT /indexed_directories/1.json
  def update
    @indexed_directory = IndexedDirectory.find(params[:id])

    respond_to do |format|
      if @indexed_directory.update_attributes(params[:indexed_directory])
        format.html { redirect_to @indexed_directory, notice: 'Indexed directory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @indexed_directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexed_directories/1
  # DELETE /indexed_directories/1.json
  def destroy
    @indexed_directory = IndexedDirectory.find(params[:id])
    @indexed_directory.destroy

    respond_to do |format|
      format.html { redirect_to indexed_directories_url }
      format.json { head :no_content }
    end
  end

  def indexing
    @indexed_directory = IndexedDirectory.find(params[:id])
    @indexed_directory.index
    redirect_to @indexed_directory
  end

  def update_stats
    @indexed_directory = IndexedDirectory.find(params[:id])
    @indexed_directory.update_stats
    redirect_to @indexed_directory.parent
  end

end
