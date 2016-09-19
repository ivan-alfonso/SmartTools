class Competition < ApplicationRecord
	belongs_to :user
	has_many :videos,  dependent: :destroy 

	validates :name, presence: true

	has_attached_file :image, styles: { medium: "1350x280", thumb: "160x160" }
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
