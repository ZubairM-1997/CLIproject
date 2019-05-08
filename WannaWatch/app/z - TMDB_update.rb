require 'uri'
require 'net/http'
require 'pry'
require 'json'
require_all 'app'
require_all 'config'

def update_movies(movie_array)
    genres = get_genres
    movie_array.each do |movie_params|
        Movie.create_with(
            description: movie_params["overview"],
            release_date: 
                if movie_params["release_date"] != ""
                    Date.strptime(movie_params["release_date"],"%Y-%m-%d")
                else nil
                end,
            title: movie_params["title"],
            genre: movie_params["genre_ids"].map{ |genre_num| genres[genre_num] }.join(', ')
            )
        .find_or_create_by(tmdb_id:movie_params["id"])
    end
end

def get_genres
    url = URI("https://api.themoviedb.org/3/genre/movie/list?language=#{$language}&api_key=#{$api_key}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    results = JSON.parse(http.request(request).read_body)

    genres_hash = {}
    results["genres"].each do |genre|
        genres_hash[genre["id"]] = genre["name"]
    end
    return genres_hash
end

def discover(year,page=1)
    url = URI("https://api.themoviedb.org/3/discover/movie?api_key=#{$api_key}&language=#{$language}&region=#{$region}&sort_by=original_title.asc&page=#{page}&primary_release_year=#{year}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    return results_hash = JSON.parse(http.request(request).read_body)
end

def discover_by_year(year)
    page_count = discover(year)["total_pages"]
    page = 1
    arr_results = []

    page_count.times do
        arr_movies = discover(year,page)["results"]
        arr_movies.each { |movie| arr_results << movie}
        page += 1
    end
    return arr_results
end

def discover_all
    year = $base_year
    while year <= $latest_year
        update_movies(discover_by_year(year))
        year += 1
    end
end

def update_series(tmdb_id)
    url = URI("https://api.themoviedb.org/3/movie/#{tmdb_id}?language=en-US&api_key=be6bc01e83db5bd420caf0e567ab2965")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    results_hash = JSON.parse(http.request(request).read_body)

    Movie.find_by(tmdb_id: tmdb_id).update(imdb_id: results_hash["imdb_id"])

    if results_hash["belongs_to_collection"] != nil
        Movie.find_by(tmdb_id: tmdb_id).update(series: results_hash["belongs_to_collection"]["name"])
    end
    sleep(0.1)
end

def update_all_series
    Movie.all.where(imdb_id: nil).each { |movie| update_series(movie.tmdb_id) }
end

def search(search_term, page=1)
    url = URI("https://api.themoviedb.org/3/search/movie?include_adult=false&page=#{page}&query=#{search_term}&language=en-US&api_key=be6bc01e83db5bd420caf0e567ab2965")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    return results_hash = JSON.parse(http.request(request).read_body)
end

def search_all_pages(search_term)
    page_count = search(search_term)["total_pages"]
    page = 1  
    arr_results = []  

    page_count.times do
        arr_movies = search(search_term,page)["results"]
        arr_movies.each { |movie| arr_results << movie}
        page += 1
    end
    update_movies(arr_results)      
end