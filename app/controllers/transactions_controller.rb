class TransactionsController < ApplicationController
 
  def create
    raise params[:transaction].inspect
    portfolio = Portfolio.find(params[:portfolio_id])
    
    ticker = params[:security][:description].gsub(/\s-\s.*/,"")
    security = find_or_create_security(ticker)  
    if security
      transaction = portfolio.transactions.create!(params[:transaction])
      transaction.security_id = security.id
      transaction.save
      #security.update_bookings
      flash[:success] = "Transaction saved"
    else
      flash[:failure] = "Security #{ticker} does not exist."
    end  
    redirect_to :controller => 'portfolios', :action => 'show_transactions', :id => portfolio.id
    
  end

  def destroy
    transaction = Transaction.find(params[:id])
    portfolio_id = transaction.portfolio_id
    transaction.destroy
    redirect_to :controller => 'portfolios', :action => 'show_transactions', :id => portfolio_id
    
  end
  
  
  
  

end
