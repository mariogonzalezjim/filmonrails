class ChangeRatingToFilm < ActiveRecord::Migration[6.1]
  def change
    change_column :films, :imdbRating, :decimal
  end
end
