class IndexedFilesController < ApplicationController
  # GET /indexed_files
  # GET /indexed_files.json
  def index
    @indexed_files = IndexedFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @indexed_files }
    end
  end

  # GET /indexed_files/1
  # GET /indexed_files/1.json
  def show
    @indexed_file = IndexedFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @indexed_file }
    end
  end

  # GET /indexed_files/new
  # GET /indexed_files/new.json
  def new
    @indexed_file = IndexedFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @indexed_file }
    end
  end

  # GET /indexed_files/1/edit
  def edit
    @indexed_file = IndexedFile.find(params[:id])
  end

  # POST /indexed_files
  # POST /indexed_files.json
  def create
    @indexed_file = IndexedFile.new(params[:indexed_file])

    respond_to do |format|
      if @indexed_file.save
        format.html { redirect_to @indexed_file, notice: 'Indexed file was successfully created.' }
        format.json { render json: @indexed_file, status: :created, location: @indexed_file }
      else
        format.html { render action: "new" }
        format.json { render json: @indexed_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /indexed_files/1
  # PUT /indexed_files/1.json
  def update
    @indexed_file = IndexedFile.find(params[:id])

    respond_to do |format|
      if @indexed_file.update_attributes(params[:indexed_file])
        format.html { redirect_to @indexed_file, notice: 'Indexed file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @indexed_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexed_files/1
  # DELETE /indexed_files/1.json
  def destroy
    @indexed_file = IndexedFile.find(params[:id])
    @indexed_file.destroy

    respond_to do |format|
      format.html { redirect_to indexed_files_url }
      format.json { head :no_content }
    end
  end
end
