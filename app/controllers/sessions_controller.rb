class SessionsController < ApplicationController

  def new
  end

  def create
    email = params[:session][:email]
    passwd = params[:session][:password]
    @user = User.find_by_email(email)
    if @user && @user.authenticate(passwd)
      sign_in @user
      redirect_to @user 
    else 
      flash[:error] = "Invalid email or password - Please try again"
      render 'new'
    end  
  end

  def destroy
    sign_out
    redirect_to root_url
  end 

end
