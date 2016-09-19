# Preview all emails at http://localhost:3000/rails/mailers/video_converted_mailer
class VideoConvertedMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/video_converted_mailer/notify
  def notify
    VideoConvertedMailer.notify
  end

end
