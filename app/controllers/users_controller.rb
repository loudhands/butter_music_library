class UsersController < Clearance::UsersController
  unloadable
  
  before_filter :admin_only
  skip_before_filter :authenticate, :only => [:new, :create]
  skip_before_filter :redirect_to_root
  filter_parameter_logging :password
  
  def index
    @users = User.all
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user].reject { |k,v| v.blank? })
      redirect_to users_path
      flash[:notice] = "User info saved."
    else
      render :action => 'edit'
    end
  end

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new params[:user]
    if @user.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
    flash[:notice] = "User deleted."
  end

  private

  def flash_notice_after_create
    flash[:notice] = "User created."
  end

  def url_after_create
    users_path
  end
end
