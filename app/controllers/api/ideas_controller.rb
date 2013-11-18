module Api
  class IdeasController < ApiController

    before_action :set_idea, only: [:show, :edit, :update, :destroy]
     
    def index
      @ideas = Idea.all
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

    private
    def set_project
      @idea = Idea.find(params[:id])
    end
      
    def idea_params
      params.require(:idea).permit(:text, :project_id)      
    end
     
  end
  
end