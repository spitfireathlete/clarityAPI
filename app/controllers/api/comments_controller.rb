module Api
  class CommentsController < ApiController
    
    before_action :set_idea
    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    
    def index
      @comments = Comment.where(:idea_id => @idea.id)
      respond_with @comments
    end
    
    def show
      respond_with @comment
    end

    def create
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id

      if @comment.save
        respond_to do |format|
          format.json { render json: @comment, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
    
    
    private
    
    def set_idea
      @idea = Idea.find(params[:idea_id])
    end
    
    def set_comment
      @comment = Comment.find(params[:id])
    end
      
    def comment_params
      params.require(:comment)
      params.permit(:text, :idea_id)     
    end
     
  end
  
end