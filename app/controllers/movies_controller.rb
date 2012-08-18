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
    if (params[:sortby] =~ /title|release_date/ ) then
      @sortby = params[:sortby]
      session[:sortby] = @sortby
    elsif (session[:sortby]) then
      @sortby = session[:sortby]
      session.delete(:sortby)
    else
      @sortby = ""
    end
    if (params[:ratings]) then
      @checked_ratings=params[:ratings].keys
      session[:checked_ratings]=params[:ratings]
    elsif (session[:checked_ratings]) then
      @checked_ratings=session[:checked_ratings]
      session.delete(:checked_ratings)
      if(@sortby) then
        redirect_to movies_path(:sortby=>@sortby, :ratings=>@checked_ratings)
      else
        redirect_to movies_path(:ratings=>@checked_ratings)
      end
    end
    Movie.scope_by_ratings(@checked_ratings)
    if (@sortby) then
      @movies = Movie.byrating.order(@sortby)
    else
      @movies = Movie.byrating.all
    end
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
