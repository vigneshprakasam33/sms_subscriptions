class MessagesController < ApplicationController
  skip_before_filter :require_login, :only => [:get_messages_on_category]
  before_action :set_message, only: [:show, :edit, :update, :destroy]


  # GET /messages
  # GET /messages.json
  def index
    @user = current_user
    @messages = Message.all
    @config_messages = ConfigMessage.where(:user_id => current_user.id)
    authorize! :update, @messages
  end

  def update_config
    user = User.find(params["user"]["id"])
    user.update(user_params)
    redirect_to messages_path
  end
  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    authorize! :update, @message
  end

  def new_category
    @categories = Category.all
    @category = Category.new
    authorize! :update, @category
  end

  def create_category
    @category = Category.new(category_params)
    authorize! :update, @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to new_category_messages_url , notice: 'Message Category was successfully created.' }
        format.json { render action: 'index', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /messages/1/edit
  def edit
  end


  def get_messages_on_category
    @msgs = Category.find_by_id(params[:category_id]).messages
    @sub = params[:subscription_id]
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    authorize! :update, @message

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: 'Message was successfully created.' }
        format.json { render action: 'index', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    authorize! :update, @message
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def destroy_category
    @category = Category.find(params[:id])
    @category.destroy
     respond_to do |format|
       format.html { redirect_to new_category_messages_url }
       format.json { head :no_content }
     end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:content, :category_id)
  end

  def category_params
    params.require(:category).permit(:name, :description , :id)
  end

  def user_params
    params.require(:user).permit(:id , config_messages_attributes: [:id , :content , :user_id]  )
  end
end
