class HomesController < ApplicationController
	def show
		@home = Home.find(params[:id])
		#@items = @home.items
	end
end
