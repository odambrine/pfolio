class Holding < ActiveRecord::Base
  attr_accessible :user_id, :portfolio_id, :admin, :show_in_graph
  
  belongs_to :user
  belongs_to :portfolio
  
  validates_presence_of :user_id, :portfolio_id
  
end
