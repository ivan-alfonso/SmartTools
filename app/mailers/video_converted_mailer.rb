class VideoConvertedMailer < ApplicationMailer

  #def notify (video)
  def notify (video)
    @video = video

    Rails.logger.info("video #{Time.now} " + video.email)
    #mail to: video.email, subject: 'Felicidades, su video ha sido cargado correctamente!'
    mail to: video.email, subject: 'SmartTools: Has participado en un concurso'
  end
end
