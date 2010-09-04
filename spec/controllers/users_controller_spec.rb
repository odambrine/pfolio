require 'spec_helper'

describe UsersController do
  integrate_views
  
  describe "GET 'index'" do
    describe "for non-signed-in users" do 
      
      it "should deny access" do
        get :index 
        response.should redirect_to(signin_path) 
        flash[:notice].should =~ /sign in/i
      end 
    end
  
    describe "for signed-in users" do
      before(:each) do 
        @user = test_sign_in(Factory(:user)) 
        second = Factory(:user, :email => "another@example.com") 
        third = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
        User.should_receive(:paginate).and_return(@users.paginate)  
      end
  
      it "should be successful" do 
        get :index 
        response.should be_success
      end
  
      it "should have the right title" do 
        get :index 
        response.should have_tag("title", /all users/i)
      end
      
      it "should have an element for each user" do 
        get :index 
        @users.each do |user|
          response.should have_tag("li", user.name) 
        end
      end 
      
      it "should paginate users" do
        get :index
        response.should have_tag("div.pagination") 
        response.should have_tag("span", "&laquo; Previous") 
        response.should have_tag("span", "1") 
        response.should have_tag("a[href=?]", "/users?page=2", "2") 
        response.should have_tag("a[href=?]", "/users?page=2", "Next &raquo;")
      end  
    end
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_tag("title",/Sign up/)
    end  
  end
  
  describe "GET 'SHOW'" do
    before(:each) do
      @user = Factory(:user)
      User.stub!(:find, @user.id).and_return(@user)
    end  
    
    it "should be successfull" do
      get :show, :id => @user
      response.should be_success
    end  
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_tag("title", /#{@user.name}/) 
    end
    
    it "should include the user's name" do 
      get :show, :id => @user 
      response.should have_tag("h2", /#{@user.name}/)
    end
    
    it "should have a profile image" do 
      get :show, :id => @user 
      response.should have_tag("h2>img", :class => "gravatar")
    end 
    
    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 =Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_tag("span.content", mp1.content)
      response.should have_tag("span.content", mp2.content)
    end  
  end  
  
  describe "POST 'create'" do 
    describe "failure" do
      before(:each) do 
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" } 
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(false) 
      end
  
      it "should have the right title" do 
        post :create, :user => @attr 
        response.should have_tag("title", /sign up/i)
      end
  
      it "should render the 'new' page" do 
        post :create, :user => @attr 
        response.should render_template('new')
      end 
      
      it "should not sign the user in" do
        post :create, :user => @attr 
        controller.should_not be_signed_in
      end
        
    end 
    
    describe "success" do
      before(:each) do 
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar",
                  :password_confirmation => "foobar" } 
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(true) 
      end
  
      it "should redirect to the user show page" do 
        post :create, :user => @attr 
        response.should redirect_to(user_path(@user))
      end
  
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome to the sample app/i
      end  
      
    end
    
  end
  
  describe "Get 'edit'" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end  
  
    it "should be successfull" do
      get :edit, :id => @user
      response.should be_success
    end  
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_tag("title", /edit user/i)
    end  
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_tag("a[href=?]", gravatar_url, /change/i)
    end  
  
  end 
  
  describe "PUT 'update'" do 
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      User.should_receive(:find).with(@user).and_return(@user)
    end  
    
    describe "failure" do
    
      before(:each) do
        @invalid_attr = { :email => "", :name => "" }
        @user.should_receive(:updated_attributes).and_return(false)
      end  
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @invalid_attr
        response.should render_template('edit')
      end  
      
      it "should have the right title" do
        put :update, :id => @user, :user => @invalid_attr
        response.should have_tag("title", /edit user/i)
      end  
    end  
    
    describe "success" do
    
      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org", :password => "barbaz", :password_confirmation => "barbaz" }
        @user.should_receive(:update_attributes).and_return(true)
      end  
      
      it "should redirect the user to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end 
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end   
    end  
    
    describe "authentication of edit/update pages" do
    
      before(:each) do
        @user = Factory(:user)
      end  
      
      describe "for non-signed-in users" do
        
        it "should deny access to 'edit" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)  
        end
        
        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end  
      end  
    end
    
    describe "for signed-in users" do
    
      before(:each) do
        wrong_user = Factory(:user, :email=>"user@example.net")
        test_sign_in(wrong_user)

      end  
        
      it "should require matching users for 'edit'" do 
        get :edit, :id => @user 
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do 
        put :update, :id => @user, :user => {} 
        response.should redirect_to(root_path)
      end
        
        
    end  
    
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do 
      @user = Factory(:user)
    end
  
    describe "as a non-signed-in user" do 
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path) 
      end
    end
  
    describe "as a non-admin user" do 
      it "should protect the page" do
        test_sign_in(@user) 
        delete :destroy, :id => @user 
        response.should redirect_to(root_path)
      end 
    end
  
    describe "as an admin user" do
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true) 
        test_sign_in(admin) 
        User.should_receive(:find).with(@user).and_return(@user) 
        @user.should_receive(:destroy).and_return(@user)
      end
  
      it "should destroy the non-admin user" do 
        delete :destroy, :id => @user 
        response.should redirect_to(users_path)
      end 
      
      it "should not destroy the admin user" do
        delete :destroy, :id => admin.id
        response.should redirect_to(users_path)
      end  
    end
  end
  
end
