class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.references :competition, foreign_key: true
      t.string :nombreAutor
      t.string :apellidoAutor
      t.string :email
      t.text :comentario
      t.string :videoConvertido
      t.string :estado, null: false, default: "En proceso"

      t.timestamps
    end
  end
end
