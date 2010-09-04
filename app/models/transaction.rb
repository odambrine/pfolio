class Transaction < ActiveRecord::Base
  attr_accessible :date, :stock_id, :operation, :quantity, :price, :cost
  attr_accessor :security
  
  belongs_to :portfolio
  belongs_to :security
  
  OPERATION_TYPES =[
    [ "Buy", "Buy" ],
    [ "Sell", "Sell" ],
    [ "Dividend", "Dividend" ]
    ]
    
    
  
end
