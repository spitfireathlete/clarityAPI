module Api
  class PrioritiesController < ApiController

    before_action :set_priority, only: [:show, :edit, :update, :destroy]
     
    def index
      @priorities = Priority.all
      respond_with @priorities
    end
    
    def show
      respond_with @priority
    end

    private
    
    def set_priority
      @priority = Priority.find(params[:priority_id])
    end
    
  end
  
end