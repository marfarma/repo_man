class RepositoriesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :find_repository, :only => [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "Couldn't find that repository."
    redirect_to root_url
  end

  def index
    @repositories = Repository.all
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repositories }
    end
  end

  def show
    @repository = Repository.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
    end
  end

  def new
    @repository = Repository.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
    end
  end

  def edit
    @repository = Repository.find(params[:id])
  end

  def create
    @repository = Repository.new(params[:repository])
    respond_to do |format|
      if @repository.save
        flash[:success] = "Repository created. You know something? <strong>You're all right!</strong>"
        format.html { redirect_to @repository }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:success] = "Repository updated. You know something? <strong>You're all right!</strong>"
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository.destroy
    flash[:success] = "Repository deleted. Repo man is always intense!"
    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_repository
    @repository = current_user.repositories.find(params[:id])
  end
end
