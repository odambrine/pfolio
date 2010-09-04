class Cashflow < ActiveRecord::Base
  attr_accessible :amount, :date
  
  belongs_to :portfolio
end
