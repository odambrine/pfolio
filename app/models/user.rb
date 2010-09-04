# == Schema Information
# Schema version: 20100712123937
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  attr_accessor :password
  
  has_many :microposts, :dependent => :destroy
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
  
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  has_many :holdings, :dependent => :destroy
  has_many :portfolios, :through => :holdings, :uniq => true
    
  before_save :encrypt_password
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  
  validates_confirmation_of :password
  
  validates_presence_of :password
  validates_length_of :password, :within => 6..40
  
  #Returns true if the user's password matches the submitted password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    save_with_validation(false)
  end  
  
  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end  
  
  def feed
    Micropost.all(:conditions => ["user_id = ?", id])
  end  
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end  
  
  def follow!
    relationships.create!(:follwed_id => followed.id)
  end  
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end  
  
  private 
  
    def encrypt_password
      unless password.nil?
        self.salt = make_salt
        self.encrypted_password = encrypt(password)
      end
    end  
  
    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end  
  
    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end  
  
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end  
  
end
