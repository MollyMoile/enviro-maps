class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!, except: [:index]

	def index
	  gon.issues = Issue.all
    

	end

  def show
    @issue_tags = @issue.tag_list

    respond_to do |format|
      format.html
      format.json { render json: @issue_tags }
    end    
  end

  def new
    @issue = Issue.new
  end

  def edit
    gon.issue = @issue
  end

  def create
    @issue = current_user.issues.new(issue_params)
    respond_to do |format|
      if @issue.save
        format.html { redirect_to new_issue_image_path(@issue), notice: 'Issue was successfully created.' }
        format.json { render action: 'index', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:title, :description, :url, :lat, :lng, :status, :organisation, :tag_list)
    end
end
