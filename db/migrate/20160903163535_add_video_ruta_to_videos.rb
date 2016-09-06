class AddVideoRutaToVideos < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :videos,:videoOriginal
  	add_attachment :videos,:videoComvertido
  	add_column :videos, :estado, :string, null: false, default: "En proceso"
  end
end
