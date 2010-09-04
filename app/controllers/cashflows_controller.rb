class CashflowsController < ApplicationController
  
  def create
    portfolio = Portfolio.find(params[:portfolio_id])
    #I tried using the different fields in cashflow but this didn't work. Calling params-cashflow does the job.
    cashflow = portfolio.cashflows.create!(params[:cashflow])
    
    flash[:success] = "Cashflow saved"
    redirect_to :controller => 'portfolios', :action => 'show_cashflows', :id => portfolio.id

  end

  def destroy
    cashflow = Cashflow.find(params[:id])
    portfolio_id = cashflow.portfolio_id
    cashflow.destroy
    redirect_to :controller => 'portfolios', :action => 'show_cashflows', :id => portfolio_id
  end

end
