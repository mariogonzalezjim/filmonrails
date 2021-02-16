class HomeController < ApplicationController
  layout :resolve_layout

  def resolve_layout
    case action_name
    when "index"
      "index"
    when "new"
      "index"
    else
      "application"
    end
  end

  def index

    if session[:user] != nil
      redirect_to "/dashboard"
    end

    @user = User.new
    @error = params[:error_login]

  end

  def login

    if User.exists?(email: params[:user][:email], password: params[:user][:password])
      session[:user] = User.find_by(email: params[:user][:email])
      redirect_to '/dashboard'
      return
    end
    # error
    redirect_to controller: 'home', action: 'index', error_login: "Credentials not valid"
  end

  def new
    @user = User.new
    @error = params[:error_form]
    #puts params
  end

  def create
    user = User.new

    if params[:user][:password] != params[:user][:password_repeat]
      redirect_to controller: 'home', action: 'new', error_form: "Error: Password don't match"
      return
    end

    if User.exists?(email: params[:user][:email])
      redirect_to controller: 'home', action: 'new', error_form: "Error: Email is already used"
      return
    end
    
    user.name = params[:user][:name]
    user.email = params[:user][:email]
    user.password = params[:user][:password]

    user.save

    redirect_to "/"
  end

  def dashboard
    if session[:user] == nil
      redirect_to "/"
    end

    @search_film = ""
    @film = ""
    @recent_movies = Film.order(:created_at).reverse_order.limit(4)
    @top_movies = Film.order(:imdbRating).reverse_order.limit(5)

    #random recomendation
    number_movies = rand(1..(Integer(Film.all.size)-1) )
    @recommended_movie = nil
    while @recommended_movie == nil do
      @recommended_movie = Film.where("imdbRating > 5.0 and id > " + String(number_movies)).limit(1)
    end
  end

  def logout 
    session[:user] = nil
    redirect_to "/"
  end

  def search_film
    redirect_to controller: 'home', action: 'search', name: params[:name], page: 1
  end

  def search_film_year
    redirect_to controller: 'home', action: 'search', year: params[:year], page: 1, name: params[:name]
  end

  def search
    if session[:user] == nil
      redirect_to "/"
    end

    @film = ""
    @year = ""
    @result = params[:name]
    @result_year = params[:year]
    @page = params[:page]

    if @page == nil
      @page = 1
    end

    if /\A\d+\z/.match(@result_year)
      response = JSON.parse(RestClient.get('http://www.omdbapi.com/?s=' + @result + '&y=' + @result_year + '&apikey=25b46a1c&page=' + @page))
    else
      response = JSON.parse(RestClient.get('http://www.omdbapi.com/?s=' + @result + '&apikey=25b46a1c&page=' + @page))
    end
    
    if response['totalResults'] != nil
      @total_results = Integer(response['totalResults'])
      @total_pages = @total_results / 10
      @array_films = response['Search']
    else
      @total_results = 0
      @total_pages = 1
      @array_films = []
    end
   
  end

  def description
    if session[:user] == nil
      redirect_to "/"
    end

    @film = ""
    @data = Film.find_by(id_film: params[:id])

    if ( @data == nil)
      @data = JSON.parse(RestClient.get('http://www.omdbapi.com/?i=' + params[:id] + '&apikey=25b46a1c'))
      # save on database
      film = Film.new
      film.id_film = params[:id]
      film.Title = @data['Title']
      film.Released = @data['Released']
      film.Year = @data['Year']
      film.Runtime = @data['Runtime']
      film.Genre = @data['Genre']
      film.Plot = @data['Plot']
      film.Country = @data['Country']
      film.Poster = @data['Poster']
      film.imdbRating = Float(@data['imdbRating'])
      film.save
    end

    #insert visit in log
    log = Log.find_by(email_user: session[:user]["email"], id_film: params[:id])
    if log == nil
      log = Log.new
      log.email_user = session[:user]["email"]
      log.id_film = params[:id]
      log.save
    else
      log.update(updated_at: Time.now)
    end
    


  end 

  def historical
    @last_movies = Film.joins('INNER JOIN logs ON films.id_film = logs.id_film').where('logs.email_user' => session[:user]["email"]).order('logs.updated_at desc').limit(20)
    @film = ""
  end

end
