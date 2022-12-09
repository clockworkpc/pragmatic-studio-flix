class AddSlugToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :slug, :string
    add_index :movies, :title, unique: true
    Movie.all.each(&:save!)
  end
end
