class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :show_portfolios]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :signed_in_user, :only => [:new, :create]
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = CGI.escapeHTML(@user.name)
  end  
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end    
  end  
  
  def edit
    #@user = User.find(params[:id])
    @title = "Edit user"
  end 
    
  def update
    #@user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:success]= "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end    
  end 
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end 
  
  def destroy
    user = User.find(params[:id])
    if user.admin?
      flash[:success] = "Cannot delete an administrator"
      redirect_to users_path
    else
      user.destroy
      flash[:success] = "User destroyed"
      redirect_to users_path
    end
  end   
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end  
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end  
    
    def signed_in_user 
        redirect_to(root_path) if signed_in?    
    end  

end
