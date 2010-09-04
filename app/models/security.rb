class Security < ActiveRecord::Base
  
  require 'yahoofinance'
  
  attr_accessible :name, :ticker, :type
  
  has_many :transactions, :dependent => :destroy, :order => "date ASC"
  has_many :portfolios, :through => :transactions
  has_many :bookings, :dependent => :destroy
  
  validates_uniqueness_of :ticker
  validates_presence_of :name,
                          :message => "Stock not found on Yahoo Finance."
  before_validation_on_create :update_stock_information
  
  def update_bookings
    self.transactions.each do |t|
      quantity=0
      if t.operation == 'Buy'
        buy_booking = self.bookings.new
        buy_booking.date = t.date
        buy_booking.quantity = t.quantity
        buy_booking.buy_price = t.price
        buy_booking.cost = t.cost
        buy_booking.dividend = 0
        buy_booking.save
      elsif t.operation == 'Sell'
        cost = 0
        price = 0
        quantity = 0
        #First set expiration date of all bookings related to transactions of this stock 
        self.bookings.each do |b|
          if not b.sell_price and not b.expiry_date           
              cost += b.cost
              price += b.buy_price * b.quantity
              quantity += b.quantity
              b.expiry_date = t.date
              b.save
          end  
        end  
        price = price / quantity if quantity!=0

        #Then create a booking for the remaining shares
        if t.quantity < quantity
          buy_booking = self.bookings.new
          buy_booking.date = t.date
          buy_booking.quantity = quantity - t.quantity
          buy_booking.buy_price = price
          buy_booking.cost = 0
          buy_booking.dividend = 0
          buy_booking.save
        end  

        #Finally, create a sell booking
        sell_booking = self.bookings.new
        sell_booking.date = t.date
        sell_booking.quantity = t.quantity
        sell_booking.buy_price = price
        sell_booking.sell_price = t.price
        sell_booking.cost = cost + t.cost
        sell_booking.dividend = 0
        sell_booking.save


      elsif t.operation == 'Dividend'
        #Coupon
        div_booking = self.bookings.new
        div_booking.date = t.date
        div_booking.quantity = 0
        div_booking.cost = 0
        div_booking.dividend = t.dividend
        div_booking.save
      end
      
    end  
  end  
  
  
  
  protected

  def quote
    @quote ||= YahooFinance::get_standard_quotes(self.ticker)[self.ticker]
  end

  def update_stock_information
    self.name = @quote.name if quote.valid?
  end
  
  
end  