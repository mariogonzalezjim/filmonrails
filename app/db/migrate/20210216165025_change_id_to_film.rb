class ChangeIdToFilm < ActiveRecord::Migration[6.1]
  def change
    change_column :films, :id_film, :string
  end
end
