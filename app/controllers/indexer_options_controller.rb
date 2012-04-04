class IndexerOptionsController < ApplicationController
  # GET /indexer_options
  # GET /indexer_options.json
  def index
    @indexer_options = IndexerOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @indexer_options }
    end
  end

  # GET /indexer_options/1
  # GET /indexer_options/1.json
  def show
    @indexer_option = IndexerOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @indexer_option }
    end
  end

  # GET /indexer_options/new
  # GET /indexer_options/new.json
  def new
    @indexer_option = IndexerOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @indexer_option }
    end
  end

  # GET /indexer_options/1/edit
  def edit
    @indexer_option = IndexerOption.find(params[:id])
  end

  # POST /indexer_options
  # POST /indexer_options.json
  def create
    @indexer_option = IndexerOption.new(params[:indexer_option])

    respond_to do |format|
      if @indexer_option.save
        format.html { redirect_to @indexer_option, notice: 'Indexer option was successfully created.' }
        format.json { render json: @indexer_option, status: :created, location: @indexer_option }
      else
        format.html { render action: "new" }
        format.json { render json: @indexer_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /indexer_options/1
  # PUT /indexer_options/1.json
  def update
    @indexer_option = IndexerOption.find(params[:id])

    respond_to do |format|
      if @indexer_option.update_attributes(params[:indexer_option])
        format.html { redirect_to @indexer_option, notice: 'Indexer option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @indexer_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexer_options/1
  # DELETE /indexer_options/1.json
  def destroy
    @indexer_option = IndexerOption.find(params[:id])
    @indexer_option.destroy

    respond_to do |format|
      format.html { redirect_to indexer_options_url }
      format.json { head :no_content }
    end
  end
end
