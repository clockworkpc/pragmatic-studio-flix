class AddSlugToGenres < ActiveRecord::Migration[7.0]
  def change
    add_column :genres, :slug, :string
    Genre.all.each(&:save)
  end
end
