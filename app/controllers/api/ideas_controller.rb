module Api
  class IdeasController < ApiController

    before_action :set_idea, only: [:show, :edit, :update, :destroy]
     
    # get all ideas where you are the author
    def index
      @ideas = Idea.where(:user_id => current_user.id)
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
    def set_idea
      @idea = Idea.find(params[:id])
    end
      
    def idea_params
      params.require(:idea).permit(:text, :project_id)      
    end
     
  end
  
end