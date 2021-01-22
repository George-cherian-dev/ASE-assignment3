class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    print("\n 3")
    print(session[:rating])
    print("\n 4")
    print(session[:sort_by])
    print("\n")
    
    @all_ratings =  Movie.all_ratings
    @param_ratings =  params[:ratings].nil? ? {} : params[:ratings]
    @ratings_to_show = params[:ratings].nil? ?  session[:rating] || @all_ratings : params[:ratings].keys ;


    @sort = params[:sort].nil? ? session[:sort_by] || "" : params[:sort]
    
    session[:rating] = @ratings_to_show
    session[:sort_by] = @sort
    
    print("\n 1")
    print(session[:rating])
    print("\n 2")
    print(session[:sort_by])
    print("\n")
    
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
