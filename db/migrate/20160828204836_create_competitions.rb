class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.text :url
      t.date :dateStart
      t.date :dateEnd
      t.string :prize

      t.timestamps
    end
  end
end
