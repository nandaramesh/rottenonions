class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if (@checked_ratings.nil?)
      @checked_ratings=[]
    end
    if (params[:ratings]) then
      @checked_ratings=params[:ratings].keys
      session[:checked_ratings]=@checked_ratings
    elsif (session[:checked_ratings]) then
      @checked_ratings=session[:checked_ratings]
    end
    Movie.scope_by_ratings(@checked_ratings)
    if (params[:sortby] =~ /title|release_date/ ) then
      @sortby = params[:sortby]
      session[:sortby] = @sortby
    elsif (session[:sortby]) then
      @sortby = session[:sortby]
    else
      @sortby = ""
    end
    if (@sortby) then
      @movies = Movie.byrating.order(@sortby)
    else
      @movies = Movie.byrating.all
    end
# render :text => "***PARAMS*** #{params.inspect} ***SESSION*** #{session.inspect}"
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
