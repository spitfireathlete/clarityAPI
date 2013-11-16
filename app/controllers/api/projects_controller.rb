module Api
  class ProjectsController < ApiController

    before_action :set_project, only: [:show, :edit, :update, :destroy]
     
    # GET /chronicles
    # GET /chronicles.json
    def index
      @projects = Project.all
      respond_with @projects
    end

    # POST /chronicles
    # POST /chronicles.json
    def create
      get_priority_from_salesforce_id
      @project = Project.new(project_params)
      
      if @project.save
        respond_with @project
      else
        respond_to do |format|
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end

    private
    def set_project
      @project = Project.find(params[:id])
    end
    
    def get_priority_from_salesforce_id
      @priority = Priority.where(:salesforce_id => project_params[:priority], :name => project_params[:priority_name]).first_or_create
    end
    
    
     # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:priority)
        params.require(:priority_name)
        params.require(:topic)
        
        params.permit(:details, :user_id)
      end
  end
  
end