class RepositoriesController < ApplicationController
  def index
    @repositories    = Repository.all
    @last_repository = Repository.find(flash[:repository_id]) if flash[:repository_id]
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      flash[:success]       = "Repository created. You know something? <strong>You're all right!</strong>"
      flash[:repository_id] = @repository.id
      redirect_to repositories_url
    else
      render :action => "new"
    end
  end
  
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy
    flash[:success] = "Repository deleted. Repo man is always intense!"
    redirect_to repositories_url
  end
  
end
