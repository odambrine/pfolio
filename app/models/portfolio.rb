class Portfolio < ActiveRecord::Base
  attr_accessible :name
  attr_accessor :admin, :show_in_graph
  
  has_many :holdings, :dependent => :destroy
  has_many :users, :through => :holdings, :uniq => true
  has_many :cashflows, :dependent => :destroy
  has_many :transactions, :dependent => :destroy, :order => "date ASC"
  has_many :securities, :through => :transactions
  
  #still to add: belongs to stock via benchmark
  
  validates_presence_of :name
  
  def after_initialize
    self.admin = true
    self.show_in_graph = true
  end  
end
