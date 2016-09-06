class Video < ApplicationRecord
  belongs_to :competition

  do_not_validate_attachment_file_type :videoOriginal #No es seguro
  has_attached_file :videoOriginal
  #validates_attachment :videoOriginal, content_type: { content_type: "video/x-ms-wmv" }
end
