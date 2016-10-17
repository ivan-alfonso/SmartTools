class Video < ApplicationRecord
  validates :comentario, presence: true
  validates :videoOriginal, attachment_presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  belongs_to :competition

  #do_not_validate_attachment_file_type :videoOriginal #No es seguro
  #has_attached_file :videoOriginal,
   # :url  => "/system/:attachment/:id/:style_:filename",
    #:path => ":rails_root/public/system/:attachment/:id/:style_:filename"
  #validates_attachment :videoOriginal, content_type: { content_type: "video/x-ms-wmv" }

  has_attached_file :videoOriginal,
          :path => "original-videos/:id/:basename.:extension",
          :processors => lambda { |a| a.is_video? ? [ :ffmpeg ] : [ :thumbnail ] }
  validates_attachment_content_type :videoOriginal, content_type: /\Avideo\/.*\Z/ 
end
