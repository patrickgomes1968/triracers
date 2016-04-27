module Api
	class RacesController < ApplicationController
	before_action :set_race, only: [:show, :edit, :update, :destroy]

  # GET /races
  # GET /races.json
  def index
    @races = Race.all.order_by(date: :desc)
  end

  # GET /races/1
  # GET /races/1.json
  def show
    @entrants = Entrant.where(:"race._id" => @race.id)
      .order_by(secs: :asc, last_name: :asc, first: :asc)
  end

  # GET /races/new
  def new
    @race = Race.new
  end

  # GET /races/1/edit
  def edit
    @races=Race.upcoming_available_to(@racer).order_by(:date.asc)
  end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(race_params)

    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, notice: 'Race was successfully created.' }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /races/1
  # PATCH/PUT /races/1.json
  def update
    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to @race, notice: 'Race was successfully updated.' }
        format.json { render :show, status: :ok, location: @race }
      else
        format.html { render :edit }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.json
  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(:name, :date, :city, :state, :swim_distance, :swim_units, :bike_distance, :bike_units, :run_distance, :run_units)
    end
	
	end #End of Race Class

	class RacersController < ApplicationController
  before_action :set_racer, only: [:show, :edit, :update, :destroy]

  # GET /racers
  # GET /racers.json
  def index
    @racers = Racer.all
  end

  # GET /racers/1
  # GET /racers/1.json
  def show
    @races=@racer.races
  end

  # GET /racers/new
  def new
    @racer = Racer.new
  end

  # GET /racers/1/edit
  def edit
    @races = Race.upcoming_available_to(@racer).order_by(:date.asc)
  end

  # POST /racers
  # POST /racers.json
  def create
    @racer = Racer.new(racer_params)

    respond_to do |format|
      if @racer.save
        format.html { redirect_to @racer, notice: 'Racer was successfully created.' }
        format.json { render :show, status: :created, location: @racer }
      else
        format.html { render :new }
        format.json { render json: @racer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /racers/1
  # PATCH/PUT /racers/1.json
  def update
    respond_to do |format|
      if @racer.update(racer_params)
        format.html { redirect_to @racer, notice: 'Racer was successfully updated.' }
        format.json { render :show, status: :ok, location: @racer }
      else
        format.html { render :edit }
        format.json { render json: @racer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /racers/1
  # DELETE /racers/1.json
  def destroy
    @racer.destroy
    respond_to do |format|
      format.html { redirect_to racers_url, notice: 'Racer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /racers/1/entries?race_id=1
  def create_entry
    @racer = Racer.find(params[:racer_id])
    @race = Race.find(params[:race_id])
    @entrant = @race.create_entrant @racer

    respond_to do |format|
      if @entrant.valid?
        format.html { redirect_to @racer, notice: 'Race entry was successfully created.' }
        format.json { render :show, status: :created, location: @racer }
      else
        format.html { redirect_to @racer, notice: "Invalid registration #{@entrant.errors.messages}" }
        format.json { render json: @entrant.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_racer
      @racer = Racer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def racer_params
      params.require(:racer).permit(:first_name, :last_name, :gender, :birth_year, :city, :state)
    end
	end #end of Racer Class

end