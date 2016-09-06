class AddCoverToCompetitions < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :competitions,:image
  end
end
