class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :title
      t.string :series
      t.string :genre
      t.text :description
      t.datetime :release_date
    end

    create_table :users do |t| #bonus - work on hashing this password
      t.string :name
      t.string :password
    end

    create_table :wannawatches do |t|
      t.integer :user_id
      t.integer :movie_id
    end
  end
end
