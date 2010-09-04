require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "example@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should require a name" do
    no_name_user = User.new(@valid_attributes.merge(:name => ""))
    no_name_user.should_not be_valid
  end  
  
  it "should require an email address" do
    no_email_user = User.new(@valid_attributes.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@valid_attributes.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@valid_attributes.merge(:email => address))
      valid_email_user.should be_valid
    end 
  end 
  
  it "should reject valid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo]
    addresses.each do |address|
      valid_email_user = User.new(@valid_attributes.merge(:email => address))
      valid_email_user.should_not be_valid
    end 
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@valid_attributes)
    user_with_duplicate_email = User.new(@valid_attributes)
    user_with_duplicate_email.should_not be_valid
  end  
  
  it "should reject email addresses identical up to the case" do
    upcased_email = @valid_attributes[:email].upcase
    User.create!(@valid_attributes)
    user_with_duplicate_email = User.new(@valid_attributes.merge(:email => upcased_email))
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "should require password" do
      User.new(@valid_attributes.merge(:password => "", :password_confirmation => ""))
      should_not be_valid
    end  
    
    it "should require a matching password_confirmation" do
      User.new(@valid_attributes.merge(:password_confirmation => "invalid"))
      should_not be_valid
    end  
    
    it "should reject short passwords" do
      short = "a" * 5
      User.new(@valid_attributes.merge(:password => short, :password_confirmation => short))
      should_not be_valid
    end  
    
    it "should reject long passwords" do
      long = "a" * 41
      User.new(@valid_attributes.merge(:password => long, :password_confirmation => long))
      should_not be_valid
    end  
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@valid_attributes)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end 
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end     
  end 
  
  describe "has_password? method" do
    before(:each) do
      @user = User.create!(@valid_attributes)
    end
    it "should be true if the passwords match" do
      @user.has_password?(@valid_attributes[:password]).should be_true
    end  
    
    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end  
  end  
  
  describe "authenticate method" do
    
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@valid_attributes[:email],"wrongpass")
      wrong_password_user.should be_nil
    end 
    
    it "should return nil on an email with no user" do
      nonexistent_user = User.authenticate("bar@foo.com", @valid_attributes[:password])
      nonexistent_user.should be_nil
    end   
    
    it "should return the user on email/password match" do
      matching_user = User.authenticate(@valid_attributes[:email], @valid_attributes[:password])
      matching_user.should == @user
    end
  end
  
  describe "remember me" do
    before(:each) do 
      @user = User.create!(@valid_attributes)
    end
  
    it "should have a remember token" do 
      @user.should respond_to(:remember_token)
    end
  
    it "should have a remember_me! method" do 
      @user.should respond_to(:remember_me!)
    end
  
    it "should set the remember token" do 
      @user.remember_me! 
      @user.remember_token.should_not be_nil
    end 
  end
  
  describe "admin attribute" do
    before(:each) do 
      @user = User.create!(@attr)
    end
  
    it "should respond to admin" do 
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do 
      @user.should_not be_admin
    end
  
    it "should be convertible to an admin" do 
      @user.toggle!(:admin) 
      @user.should be_admin
    end 
  end
  
  describe "micropost associations" do
  
    before(:each) do
      @user = User.create(@valid_attributes)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.days.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a micropost attribute" do
      @user.should respond_to(:microposts)
    end    
    
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1,@mp2].find_by_id(micropost.id).should be_nil
    end  
  end  
end
