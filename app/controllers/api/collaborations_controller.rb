# nested resource for projects
module Api
  class CollaborationsController < ApiController

    before_action :set_project
     
    # get all collaborators for the project
    # /projects/:project_id/collaborations
    def index
      @collaborations = Collaboration.where(:project_id => params[:project_id])
      respond_with @collaborations
    end
    
    def show
      respond_with @collaboration
    end

    def create
      @collaboration = Collaboration.where(:user_id => collab_params[:user_id], :project_id => collab_params[:project_id]).first_or_create
      
      if @collaboration.save!
        respond_to do |format|
          format.json { render json: @collaboration, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: @collaboration.errors, status: :unprocessable_entity }
        end
      end
    end
    
    
    private
    def set_project
      @project = Project.find(params[:project_id])
    end
      
    def collab_params
      params.require(:collaboration).permit(:user_id)
      params.permit(:project_id, :user_id, :email)      
    end
     
  end
  
end