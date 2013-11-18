module Api
  class CommentsController < ApiController

    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    
    # get all comments where you are the author
    def index
      @comments = Comment.where(:user_id => current_user.id)
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
    def set_comment
      @comment = Comment.find(params[:id])
    end
      
    def comment_params
      params.require(:comment).permit(:text, :idea_id)      
    end
     
  end
  
end