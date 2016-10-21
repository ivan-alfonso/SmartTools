require 'fileutils'

class VideoConversionWorker
  include AwsSqsHelper

  #def self.send_mail_ses(v)
  #  @video = v
  #  ses = AWS::SES::Base.new(
  #    :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  #    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  #  )
  #  ses.send_email(
  #    :to        => [@video.user_email],
  #    :source    => '"SmartTools" <cloudcomputing.g17@gmail.com>',
  #    :subject   => 'Video exitosamente convertido',
  #    :text_body => 'Tu video ha sido recibido y convertido exitosamente'
  #  )
  #end

  def perform 
    message_from_queue = obtain_message_from_queue[0]
    if message_from_queue

      # Searching the video
      video = Video.find(message_from_queue.body)
      if video && video.estado == "En proceso"
        folderconverted = "converted-videos"
        folderVideoOriginal = "original-videos"

          s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region: ENV['AWS_REGION']
          )

          path_videoOriginal = Rails.root.join("public", folderVideoOriginal)
          unless Dir.exist?(path_videoOriginal)
            FileUtils.mkdir_p(path_videoOriginal)
          end

          downloadVideo = folderVideoOriginal + "/" + video.id.to_s + "/" + video.videoOriginal_file_name.to_s
          videoToConvert = path_videoOriginal.to_s + "/" + video.videoOriginal_file_name.to_s
          Rails.logger.info(" #{Time.now} Comenzando descarga de video: " + video.videoOriginal_file_name.to_s)
          s3.bucket(ENV['S3_BUCKET_NAME']).object(downloadVideo).get(response_target: videoToConvert.to_s)
          Rails.logger.info(" #{Time.now} Descarga de video completa: " + video.videoOriginal_file_name.to_s)


          path_videoConvertido = Rails.root.join("public", folderconverted)
          videoConvertido = path_videoConvertido.to_s + "/" + video.id.to_s + '.mp4'
          nameVideoConverted = "/" + folderconverted + "/" + video.id.to_s + '.mp4'


          unless Dir.exist?(path_videoConvertido)
            FileUtils.mkdir_p(path_videoConvertido)
          end

          unless File.exist?(videoConvertido)
            Rails.logger.info(" #{Time.now} Comenzando a convertir video: " + video.videoOriginal_file_name.to_s)
            movie = FFMPEG::Movie.new(videoToConvert.to_s)

            movie.transcode(videoConvertido)
            Rails.logger.info(" #{Time.now} Video convertido: " + video.videoOriginal_file_name.to_s)

            

            ###Almacenar video cnvertido en AWS S3
            s3 = Aws::S3::Resource.new(
              credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
             region: ENV['AWS_REGION']
            )

            obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(folderconverted + '/' + video.id.to_s + '.mp4')
            Rails.logger.info(" #{Time.now} Subiendo video a S3: " + video.videoOriginal_file_name.to_s)
            obj.upload_file(videoConvertido, acl:'public-read')
            obj.public_url
            Rails.logger.info(" #{Time.now} Video cargado en S3: " + video.videoOriginal_file_name.to_s)
            Rails.logger.info(" #{Time.now} URL video: " + obj.public_url.to_s)

            videoCloudFront = '//d3smpe5hs8b20c.cloudfront.net' + nameVideoConverted.to_s

            #video.update(estado: 'Procesado', videoConvertido: obj.public_url.to_s)
            video.update(estado: 'Procesado', videoConvertido: videoCloudFront.to_s)
            VideoConvertedMailer.notify(video).deliver

            delete_message_from_queue(message_from_queue.receipt_handle)

            FileUtils.rm(videoToConvert.to_s)
            FileUtils.rm(videoConvertido.to_s)
          end
        end
      end
  end
end
