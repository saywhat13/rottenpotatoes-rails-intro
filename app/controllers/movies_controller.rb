class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    if params[:sort_by] == nil 
      if session[:current_sort_by] == nil
        if params[:ratings] == nil
          if session[:current_ratings] == nil
            session[:current_ratings] = @all_ratings
		        redirect_to movies_path(:ratings => @all_ratings)
		      else
		        redirect_to movies_path(:ratings => session[:current_ratings])
	        end
        else
          session[:current_ratings] = params[:ratings]
          if params[:ratings].is_a? Array
	          ratings = params[:ratings]
          else
	          ratings = params[:ratings].keys
          end
          @movies = Movie.where("rating IN (?)", ratings)
 	      end
 	    else
	      if params[:ratings] == nil
	        redirect_to movies_path(:ratings => session[:current_ratings], :sort_by => session[:current_sort_by])
	      else
		      session[:current_ratings] = params[:ratings]
		      redirect_to movies_path(:ratings => session[:current_ratings], :sort_by => session[:current_sort_by])
	      end
      end
    else
      session[:current_ratings] = params[:ratings]
      session[:current_sort_by] = params[:sort_by]
      if params[:ratings].is_a? Array
		      ratings = params[:ratings]
	      else
		      ratings = params[:ratings].keys
        end
      @movies = Movie.where("rating IN (?)",params[:ratings].keys).order(params[:sort_by])
    end
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

end
