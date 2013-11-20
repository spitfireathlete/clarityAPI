module Api
  class CommentsController < ApiController
    
    before_action :set_idea, except: [:upvote, :downvote]
    before_action :set_comment, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
    
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
      @comment.idea_id = @idea.id

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
    
    def upvote
      if (@comment.upvotes.nil?) then
        @comment.upvotes = 0
      end
      
      @comment.upvotes = @comment.upvotes + 1
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
    
    def downvote
      if (@comment.downvotes.nil?) then
        @comment.downvotes = 0
      end
      
      @comment.downvotes = @comment.downvotes + 1
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
      @comment = Comment.find(params[:comment_id])
    end
      
    def comment_params
      params.require(:comment).permit(:text)   
    end
     
  end
  
end