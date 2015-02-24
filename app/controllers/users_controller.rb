class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :signin, :login, :logout]
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  def login
    if request.post?
      @user, res = User.login(params[:user][:login], params[:user][:password])
      if @user and res == :success
        session[:uid] = @user.uuid
        redirect_to edit_user_path(:id => @user.uuid)
      else
        redirect_to signin_path , :alert => "Invalid username or password"
      end
    else
      redirect_to signin_path
    end
  end

  def logout
    session[:is_admin] = nil
    session[:uid] = nil
    session.clear
    flash[:message] = 'Logged out'
    redirect_to signin_path
  end

  def signin
    render "users/signin", :layout => false
  end

  def jobs
    @jobs = Job.all
    authorize! :update, @jobs
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    authorize! :update, @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    default_category = Category.find_by_name("Business")
    @user = User.new(:time_zone => "Stockholm")
    s = @user.subscriptions.build(:subscription_message => "", :duration => 30, :category_id => default_category.id)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to new_user_path, notice: 'Your SMS Subscription has been activated.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #only admin or same user can update user object
    if current_user.is_admin.blank? and current_user.uuid != @user.uuid
      raise CanCan::AccessDenied
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(:id => @user.uuid), notice: 'Settings successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_uuid(params[:id])
    @user ||= User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    ActionController::Parameters.permit_all_parameters = true
    params.require(:user) #.permit(:name, :surname, :phone, :password, :email, :time_zone)
  end
end
