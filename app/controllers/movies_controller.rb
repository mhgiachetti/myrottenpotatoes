class MoviesController < ApplicationController

  def initialize
    super
    @all_ratings = Movie.all_ratings
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    if ((not params.has_key?(:sort)) && session.has_key?(:sort)) || ((not (params.has_key?(:ratings) || params.has_key?(:commit))) && session.has_key?(:ratings))
      flash.keep
      redirect_to :action => "index", :sort => session[:sort], :ratings => session[:ratings]
    end
      
    @columnsort = params[:sort]
    @ratings = params[:ratings]
    
    session[:sort] = @columnsort
    session[:ratings] = @ratings
    
    if @ratings 
      condition = @ratings.map{"rating = ?"}.join(" or ")
      condition = [condition] + @ratings.keys
    else
      @ratings = {}
    end    
    @movies = Movie.find(:all,:conditions => condition, :order => @columnsort)
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
