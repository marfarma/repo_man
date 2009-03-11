class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      flash[:success] = 'The repository was successfully created.'
      redirect_to repositories_url
    else
      render :action => "new"
    end
  end
end
