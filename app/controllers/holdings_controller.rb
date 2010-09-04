class HoldingsController < ApplicationController
  
  def destroy
    @holding = Holding.find(params[:id])
    @holding.destroy
    redirect_to :controller => 'portfolios', :action => 'show_holdings'
    
    
  end  
  
end
