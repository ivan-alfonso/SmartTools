class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.text :url
      t.date :dateStart
      t.date :dataEnd
      t.string :prize

      t.timestamps
    end
  end
end
