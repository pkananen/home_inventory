class HomesController < ApplicationController
	before_filter :signed_in_user, only: :show
	before_filter :correct_user, only: :show

    def new
        @home = Home.new
    end

    def edit
    end

	def show
		@home = Home.find(params[:id])
		#@items = @home.items
	end

    def create
        @home = current_user.homes.build(params[:home])
        if @home.save
            flash[:success] = "Home successfully created!"
            redirect_to @home
        else
            render 'new'
        end
    end

    def destroy
    end

	private
		def signed_in_user
      		unless signed_in?
        		store_location
        		redirect_to signin_url, notice: "Please sign in." unless signed_in?
      		end
    	end

    	def correct_user
    		@home = Home.find(params[:id])
    		@user = @home.user

    		redirect_to(root_path) unless current_user?(@user)
    	end
end
