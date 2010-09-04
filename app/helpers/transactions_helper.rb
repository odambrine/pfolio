module TransactionsHelper
  
  def get_security_id(security)
    security = Security.find_by_ticker(security)
    if security
      security_id = security.id
    else
      #get the details from yahoo finance and create the 
    end    
    
  end  
end
