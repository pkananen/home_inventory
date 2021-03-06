class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_filter :load_user, only: [:edit, :update, :show]
  before_filter :admin_user, only: :destroy
  before_filter :non_signed_in_user, only: [:new, :create]
  before_filter :before_index, only: :index

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Home Inventory Manager!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
    @homes = @user.homes
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

    def non_signed_in_user
      redirect_to(root_path) unless !signed_in?
    end

    def load_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless check_correct_user(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def before_index
      if current_user.nil?
        redirect_to(signin_url)
      else
        redirect_to(current_user) unless current_user.admin?
      end
    end
end