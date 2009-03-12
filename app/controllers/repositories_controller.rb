class RepositoriesController < ApplicationController
  def index
    @repositories    = Repository.all
    @last_repository = Repository.find(flash[:repository_id]) if flash[:repository_id]
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
end
