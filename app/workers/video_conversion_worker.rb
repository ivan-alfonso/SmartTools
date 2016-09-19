class VideoConversionWorker
  def perform
  	#@videos_no_convertidos = Video.where("estado = ? AND videoOriginal_content_type != ?", "En proceso", "video/mp4")
    @videos_no_convertidos = Video.where("estado = ?", "En proceso")

    numeroVideosConvertidos = 0

  	@videos_no_convertidos.each do |video|
    	#vc_path = Rails.root.join("videos convertidos", video.id.to_s)
    	#Dir.mkdir(vc_path) unless File.exists?(vc_path)
    	#Se carga el video a convertir

    	videoToConvert = Rails.root.join("public", video.videoOriginal.path)
      path_videoConvertido = Rails.root.join("public", "converted_videos")
      videoConvertido = path_videoConvertido.to_s + "/" + video.id.to_s + '.mp4'
      nameVideoConverted = "/converted_videos/" + video.id.to_s + '.mp4'

      unless File.exist?(videoConvertido)

        movie = FFMPEG::Movie.new(videoToConvert.to_s)

        movie.transcode(videoConvertido)
        Rails.logger.info(" #{Time.now} Video convertido: " + videoConvertido.to_s)
        numeroVideosConvertidos = numeroVideosConvertidos + 1

      
        video.update(estado: 'Procesado', videoConvertido: nameVideoConverted.to_s)
        VideoConvertedMailer.notify(video).deliver

      end
    end

    Rails.logger.info(" #{Time.now} Video convertidos: " + numeroVideosConvertidos.to_s)
  end
end