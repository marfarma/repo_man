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
      flash[:success] = "Repository created. You know something? <strong>You're all right!</strong>"
      redirect_to repositories_url
    else
      render :action => "new"
    end
  end
end
