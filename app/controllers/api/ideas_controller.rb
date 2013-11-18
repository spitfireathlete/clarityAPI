module Api
  class IdeasController < ApiController

    before_action :set_project, except: [:upvote, :downvote]
    before_action :set_idea, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
     
    def index
      @ideas = Idea.where(:project_id => @project.id)
      respond_with @ideas
    end
    
    def show
      respond_with @idea
    end

    def create
      @idea = Idea.new(idea_params)
      @idea.user_id = current_user.id
      
      if @idea.save
        respond_to do |format|
          format.json { render json: @idea, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: @idea.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def upvote
      if (@idea.upvotes.nil?) then
        @idea.upvotes = 0
      end
      
      @idea.upvotes = @idea.upvotes + 1
      if @idea.save
        respond_to do |format|
          format.json { render json: @idea, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: @idea.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def downvote
      if (@idea.downvotes.nil?) then
        @idea.downvotes = 0
      end
      
      @idea.downvotes = @idea.downvotes + 1
      if @idea.save
        respond_to do |format|
          format.json { render json: @idea, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: @idea.errors, status: :unprocessable_entity }
        end
      end
    end
        
    
    private
    
    def set_project
      @project = Project.find(params[:project_id])
    end
    
    def set_idea
      @idea = Idea.find(params[:idea_id])
    end
      
    def idea_params
      params.require(:idea)
      params.permit(:project_id, :text)
 
    end
     
  end
  
end