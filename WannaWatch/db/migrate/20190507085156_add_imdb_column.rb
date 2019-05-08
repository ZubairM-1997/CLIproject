class AddImdbColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :imdb_id, :string
    add_column :users, :admin, :boolean, :default => false
  end
end
