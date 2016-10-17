class VideosController < ApplicationController
  include AwsSqsHelper
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :set_competition

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
    @videos_no_convertidos = Video.where("estado = ?", "En proceso")
    #@videos = Video.order(created_at: :desc)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    #1st you retrieve the post thanks to params[:post_id]
    competition = Competition.find(params[:competition_id])
    #2nd you retrieve the comment thanks to params[:id]
    @video = competition.videos.find(params[:id])
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    @video.competition = @competition

    respond_to do |format|
      if @video.save
        send_msg_to_queue(@video.id.to_s)
        flash[:success] = "Hemos recibido tu video y lo estamos procesando para que sea publicado. Tan pronto el video quede publicado en la página del concurso te notificaremos por email. Gracias"
        format.html { redirect_to @video.competition, notice: '' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video.competition, notice: 'Video modificado correctamente..' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to @competition, notice: 'Video eliminado.' }
      format.json { head :no_content }
    end
  end

  private
    def set_competition
      @competition = Competition.find(params[:competition_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:competition_id, :nombreAutor, :apellidoAutor, :email, :comentario, :videoOriginal, :videoConvertido, :estado)
    end
end
