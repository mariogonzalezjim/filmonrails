class AddIdToFilm < ActiveRecord::Migration[6.1]
  def change
    add_column :films, :id_film, :integer
  end
end
