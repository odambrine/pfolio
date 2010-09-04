class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end  
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end    
  
  def show_portfolios 
       @portfolio = current_user.portfolios.new
       @portfolios = current_user.portfolios.paginate(:page => params[:page])   
  end
  
  

end
