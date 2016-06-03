class PortalsController < ApplicationController
  before_action :set_portal, only: [:show, :edit, :update, :destroy]

  # GET /portals
  # GET /portals.json
  def index
    scope = current_user.portals.includes(:destinations)
    @portals = scope.all
    respond_to do |format|
      format.html
      format.json { render json: @portals }
    end
  end

  # GET /portals/1
  # GET /portals/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @portal }
    end
  end

  # GET /portals/new
  def new
    @portal = current_user.portals.build
  end

  # GET /portals/1/edit
  def edit
  end

  # POST /portals
  # POST /portals.json
  def create
    @portal = current_user.portals.new(portal_params)

    respond_to do |format|
      if @portal.save
        format.html { redirect_to @portal, notice: 'Portal was successfully created.' }
        format.json { render :show, status: :created, location: @portal }
      else
        format.html { render :new }
        format.json { render json: @portal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portals/1
  # PATCH/PUT /portals/1.json
  def update
    respond_to do |format|
      if @portal.update(portal_params)
        format.html { redirect_to @portal, notice: 'Portal was successfully updated.' }
        format.json { render :show, status: :ok, location: @portal }
      else
        format.html { render :edit }
        format.json { render json: @portal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portals/1
  # DELETE /portals/1.json
  def destroy
    @portal.destroy
    respond_to do |format|
      format.html { redirect_to portals_url, notice: 'Portal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portal
      @portal = current_user.portals.includes(:destinations).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portal_params
      params.require(:portal).permit(:title, :slug, :destinations_count)
    end
end
