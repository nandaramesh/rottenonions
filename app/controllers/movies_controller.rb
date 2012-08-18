class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @checked_ratings=[]
    @sortby = ""
    redirect=false
    if (params[:ratings]) then
      @checked_ratings=params[:ratings].keys
      session[:ratings]=params[:ratings]
    elsif (session[:ratings] and !params[:commit]) then
      @ratings=session[:ratings]
      session.delete(:ratings)
      redirect=true
    end
    if (params[:sortby]) then
      @sortby = params[:sortby]
      session[:sortby] = @sortby
    elsif (session[:sortby]) then
      @sortby = session[:sortby]
      session.delete(:sortby)
      redirect=true
    end
    if redirect
      flash.keep
      redirect_to movies_path(:sortby=>@sortby, :ratings=>@ratings)
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
