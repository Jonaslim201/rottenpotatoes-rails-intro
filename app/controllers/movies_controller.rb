class MoviesController < ApplicationController
  before_action :get_session_params, only: [:index]

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = ratings_to_show_hash
    @movies = Movie.with_ratings(@ratings_to_show_hash)
    @ratings_to_show_hash.empty? ? @movies = Movie.with_ratings(@all_ratings) : Movie.with_ratings(@ratings_to_show_hash)

    sort_by = params[:sort_by]
    session[:sort_by] = params[:sort_by]
    
    @movies = @movies.order(sort_by) if sort_by
    @title_hilite = "hilite bg-warning" if sort_by == "title"
    @release_date_hilite = "hilite bg-warning" if sort_by == "release_date"
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

  def ratings_to_show_hash
    Rails.logger.debug(params[:ratings])
    session[:ratings] = params[:ratings]
    if params[:ratings].present?
      params[:ratings].keys
    else
      {}
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def get_session_params
    Rails.logger.debug(params[:ratings])
    Rails.logger.debug(params[:ratings].nil?)
    params[:sort_by] ||= session[:sort_by] if session[:sort_by]
    if params[:refreshed].nil?
      params[:ratings] ||= session[:ratings] if session[:ratings]
    end
  
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
