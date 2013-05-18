class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new  
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      sign_in @user
      flash[:success] = "Welcome to connectMe"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end 

  def update
    @user = User.find(params[:id])
    passwd = params[:user][:password]
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
 private

  def signed_in_user
    if(! signed_in? )
      flash[:notice] = "Please sign in"
      redirect_to signin_path
    end
  end  

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    if(!current_user.admin?)
      flash[:notice] = "You must be the Admin"
      redirect_to root_path
    end
  end

end
