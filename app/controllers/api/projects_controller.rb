module Api
  class ProjectsController < ApiController

    before_action :set_project, only: [:show, :edit, :update, :destroy]
    
    def index     
      @projects = Project.all   
      respond_with @projects
    end
    
    def contributions
      my_projects = Project.where(:user_id => current_user.id)
      my_collaborations = Collaboration.where(:user_id => current_user.id)
      projects_contributed_to = my_collaborations.map {|e| e.project}
      
      @projects = my_projects.concat(projects_contributed_to)
      respond_with @projects
    end
    
    def show
      respond_with @project
    end

    def create
      get_priority_from_salesforce_id
      @project = Project.new(project_params)
      @project.priority_id =  @priority.id
      @project.user_id = current_user.id
      
      if @project.save
        respond_to do |format|
          format.json { render json: @project, status: :created }
        end
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
      @priority = Priority.where(priority_params).first_or_create
      puts @priority
    end
    
    
     # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:project).permit(:topic, :details)
        
      end
      
      def priority_params
        params.require(:priority).permit(:name, :salesforce_id)
      end
  end
  
end