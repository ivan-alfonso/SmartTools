class AddVideoRutaToVideos < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :videos,:videoOriginal
  end
end
