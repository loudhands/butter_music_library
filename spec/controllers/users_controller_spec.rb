require 'spec_helper'

describe UsersController do

 describe "GET index" do
   it "should let me see all the users if I'm an admin" do
     User.delete_all
     @admin = Factory(:user, :admin => true)
     sign_in_as @admin
     get :index
     assigns['users'].length.should == 1
     response.should be_success
   end
   
   it "should not let me see this page if I am not an admin" do
     User.delete_all
     @user = Factory(:user)
     sign_in_as @user
     get :index
     response.should redirect_to(sign_in_path)
   end
 end
 
 describe "GET new" do
   it "should let me create a new user if I'm an admin" do
     User.delete_all
      @admin = Factory(:user, :admin => true)
      sign_in_as @admin
      get :new
      response.should be_success
   end
   
   it "should not let me create a user if I'm not an admin" do
     User.delete_all
      @user = Factory(:user)
      sign_in_as @user
      get :new
      response.should redirect_to(sign_in_path)
   end
 end
 
 describe "POST create" do
   it "should let me create if I'm an admin" do
      User.delete_all
      @admin = Factory(:user, :admin => true)
      sign_in_as @admin
      post :create, :user => {:email => Faker::Internet.email, :password => "giraffe", :password_confirmation => "giraffe", :admin => false}
      User.count.should == 2
      response.should redirect_to(users_path)
      flash[:notice].should == "User created."
   end
   
   it "should not let me create if I'm not an admin" do
       User.delete_all
       @user = Factory(:user)
       sign_in_as @user
       post :create, :user => {:email => Faker::Internet.email, :password => "giraffe", :password_confirmation => "giraffe", :admin => false}
       User.count.should == 1
       response.should redirect_to(sign_in_path)
    end
 end
 
 describe "PUT update" do
   it "should let me update user info if I'm an admin" do
     User.delete_all
     @admin = Factory(:user, :admin => true)
     @other_user = Factory(:user)
     sign_in_as @admin
     put :update, :user => {:email => "elmar@test.com", :password => "giraffe", :password_confirmation => "giraffe", :admin => false}, :id => @other_user.id
     User.find(@other_user.id).email.should == "elmar@test.com"
     response.should redirect_to(users_path)
     flash[:notice].should == "User info saved."
   end
   
   it "should not let me update user info if I'm not an admin" do
     User.delete_all
      @user = Factory(:user)
      @other_user = Factory(:user)
      sign_in_as @user
      put :update, :user => {:email => "elmar@test.com", :password => "giraffe", :password_confirmation => "giraffe", :admin => false}, :id => @other_user.id
      response.should redirect_to(sign_in_path)
   end
 end
 
 describe "DELETE destroy" do
   it "should let me delete a user if I'm an admin" do
     User.delete_all
      @admin = Factory(:user, :admin => true)
      @other_user = Factory(:user)
      sign_in_as @admin
      delete :destroy, :id => @other_user.id
      User.count.should == 1
      response.should redirect_to(users_path)
      flash[:notice].should == "User deleted."
   end
   
   it "should not let me delete a user if I'm not an admin" do
      User.delete_all
       @user = Factory(:user)
       @other_user = Factory(:user)
       sign_in_as @user
       delete :destroy, :id => @other_user.id
       response.should redirect_to(sign_in_path)
   end
 end

end
