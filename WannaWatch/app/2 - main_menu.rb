def main_menu
    selection = nil
    until selection == 'Logout'
        selection = $prompt.select("", per_page: 10) do |a|
            a.choice 'What do you WannaWatch?'
            a.choice 'View my list'
            a.choice 'Logout'
        end

        case selection 

        when 'What do you WannaWatch?'
            find_movies
            
        when 'View my list'
            view_my_list

        when 'Logout'
            random_quotes_generator($goodbyes)
            $current_user = nil
            return

            sleep($naptime)
        end 
    end
    return
end

def find_movies
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'Browse by title'
        a.choice 'Browse by series'
        a.choice 'Browse by genre'
        a.choice 'Browse future releases'
        a.choice "Can't find a movie in our library?"
        a.choice "Back to the menu"
    end

    case selection
    
    when 'Browse by title'
        browse_movies(Movie.all)

    when 'Browse by series' 
        series = series_picker
        browse_by_series(series)
    
    when 'Browse by genre'
        genre = genre_picker
        browse_by_genre(genre)

    when 'Browse future releases' 
        browse_movies(Movie.all.where("release_date > ?",Date.today))

    when "Can't find a movie in our library?"
        search_new_movie

    when "Back to the menu"
        return
    end
end 

def series_picker
    series = Movie.series
    selection = $prompt.select("What series would you like to see movies from?", series, filter: true)
end

def browse_by_series(series)
    movies = Movie.column_contains("series", series)
    browse_movies(movies)
end

def genre_picker
    genres = Movie.genres
    selection = $prompt.select("What genre would you like to see movies from?", genres, filter: true)
end

def browse_by_genre(genre)
    movies = Movie.column_contains("genre", genre)
    browse_movies(movies)
end

def search_new_movie
    puts "To keep things speedy, our database only stores movies from the year 2000 onward. But fear not! We can find your favorite."
    search_term = $prompt.ask("What's it called? (enter a full or partial title)")
    
    spinner = TTY::Spinner.new("[:spinner] Consulting the hive mind...", format: :pulse_2)
    spinner.auto_spin
    search_all_pages(search_term)
    spinner.stop('Done!')

    browse_movies(Movie.all.where("title LIKE ?","%#{search_term}%"))
end

def browse_movies(movies)
    parsed = []
    movies.each { |movie| parsed << "#{movie.title}" + Rainbow("###{movie.tmdb_id}").hide }
    selection = $prompt.select("Pick a movie to see what it's about:", parsed, filter: true)
    target_movie = Movie.find_by(tmdb_id:selection.split("##")[1])
    description_view(target_movie)
    add_wannawatch(target_movie)
end

def view_my_list
    index = 1
    table = nil
    table = TTY::Table.new [' # ', 'Title                         ','Genre    ', 'Release Date     '], []
    $current_user.wannawatches.sort_by { |ww| ww.movie.release_date }.map do |ww| 
        table << [index, ww.movie.title, ww.movie.genre.split(", ").sort.join(", "), ww.movie.release_date.strftime('%d %b %Y')]
        index += 1
    end

    puts table.render(:unicode, alignments: [:center, :left, :left, :left])
    
    choice = $prompt.ask("Would you like to explore more? Enter the number of the movie you'd like to look at, or 0 to go back.") do |q|
        q.in("0-#{index-1}")
        q.messages[:range?] = "Please enter a valid number."
    end


    if choice.to_i == 0
        return
    else
        movie = Movie.find_by(title:(table[(choice.to_i)-1,1]))
        description_view(movie)
        browse_others_like(movie)
    end
end

def description_view(movie)
    small_break
    puts movie.title
    border

    puts "Release date: #{movie.release_date.strftime('%d %b %Y')}"
    puts "Genre: #{movie.genre}"
    if movie.series != nil
        puts "Series: #{movie.series}"
    end
    
    small_break
    puts movie.description
    small_break
end

def browse_others_like(movie)
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'Browse other movies from this genre'
        if movie.series != nil
            a.choice 'Browse other movies from this series'
        end
        a.choice "Don't WannaWatch this anymore?"
        a.choice 'Main menu'

    end

    case selection 

    when 'Browse other movies from this genre'
        browse_by_genre(movie.genre)

    when "Don't WannaWatch this anymore?"
        if $prompt.yes?("Are you sure you don't WannaWatch this one?")
            
            Wannawatch.find_by(user_id:$current_user, movie_id:movie.id).destroy
            $current_user = User.find_by(id:$current_user.id)
            puts "Pew pew pew. It's gone."
            small_break
        else
            puts "No worries - haven't changed a thing!"
            small_break
            sleep($naptime)
        end

        return
        
    when 'Browse other movies from this series'
        browse_by_series(movie.series)

    when 'Main menu'
        return
    end 
end

def add_wannawatch(movie)
    selection = $prompt.select("How's this look?") do |a|
        a.choice "I'd WannaWatch this!"
        a.choice "Let's pick another."
    end

    case selection
    when "I'd WannaWatch this!"
        Wannawatch.find_or_create_by(movie_id: movie.id, user_id:$current_user.id)
        small_break
        $current_user = User.find_by(id:$current_user.id)
        puts "This movie's been added to your list!"

    when "Let's pick another."
        return
    end
end