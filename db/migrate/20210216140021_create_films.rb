class CreateFilms < ActiveRecord::Migration[6.1]
  def change
    create_table :films do |t|
      t.string :Title
      t.string :Released
      t.string :Year
      t.string :Runtime
      t.string :Genre
      t.string :Plot
      t.string :Country
      t.string :Poster
      t.string :imdbRating

      t.timestamps
    end
  end
end
