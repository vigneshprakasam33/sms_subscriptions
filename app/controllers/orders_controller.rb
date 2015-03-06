class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, :only => [:express, :index, :new , :buy_more , :buy_more_failed]
  protect_from_forgery :except => [:express, :new, :index]
  # GET /orders
  # GET /orders.json
  def index
    @user = User.find_by_payment_token(params[:token])
    @user.destroy
    flash[:error] = "Payment failed"
    respond_to do |format|
      format.html { redirect_to new_user_path }
    end
  end

  #sample. not used
  #def express
  #  response = EXPRESS_GATEWAY.setup_purchase(100,
  #                                            :ip => request.remote_ip,
  #                                            :return_url => "https://4a163662.ngrok.com/orders/new",
  #                                            :cancel_return_url => "https://4a163662.ngrok.com/orders"
  #  )
  #  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  #end


  #invoked from paypal
  # GET /orders/new
  def new
    @order = Order.new(:express_token => params[:token], :payment_method => "paypal")
    @user = User.find_by_payment_token(@order.express_token)
    @order.price = @user.calculate_total_in_cents / 100
    @order.save
    @user.orders << @order

    respond_to do |format|
      if @order.purchase
        logger.debug "======>successful purchase"
        if @user
          @user.update(:activate => true)
          #send welcome message
          @user.welcome_message

          #activate subscriptions
          @user.subscriptions.each do |s|
            s.subscription_message_fill
            s.enqueue_first_job
          end


          format.html { redirect_to new_user_path, notice: 'Thanks for the purchase. Your SMS Subscription has been activated.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          logger.debug "==========> can't find user based on token"
          @user.terms = false
          flash[:error] = "Payment failed"
          format.html { redirect_to new_user_path }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        logger.debug "======>failed purchase"
        temp_user = @user
        @user.destroy
        @user = temp_user
        flash[:error] = "Payment failed"
        format.html { redirect_to new_user_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


  end

  #for buy more orders
  def buy_more
    @order = Order.new(:express_token => params[:token], :payment_method => "paypal")
    @user = User.find_by_payment_token(@order.express_token)
    @order.price = (@user.temp_buy_more.to_f).to_s
    logger.debug "=========>Amount billed for purchase===>" + @order.price
    @order.save
    @user.orders << @order

    respond_to do |format|
      if @order.purchase
        logger.debug "======>successful purchase"
        if @user
          #activate new subscriptions
          @user.subscriptions.where(:buy_more => true).each do |s|
            s.subscription_message_fill
            s.enqueue_first_job

            #to save from deletion when future subscriptions payment fails
            s.update :buy_more => false
          end
          format.html { redirect_to buy_more_user_path(:id => @user.uuid), notice: 'Thanks for the purchase. Your SMS Subscription has been activated.' }
        else
          logger.debug "==========> can't find user based on token"
          flash[:error] = "Payment failed"
          format.html { redirect_to buy_more_user_path(:id => @user.uuid) }
        end
      else
        logger.debug "======>failed purchase"
        #all subscriptions in buy more deleted
        @user.subscriptions(:buy_more => true).destroy_all
        flash[:error] = "Payment failed"
        format.html { redirect_to buy_more_user_path(:id => @user.uuid) }
      end
    end

  end


  def buy_more_failed
    @user = User.find_by_payment_token(params[:token])
    @user.subscriptions(:buy_more => true).destroy_all
    flash[:error] = "Payment failed"
    respond_to do |format|
      format.html { redirect_to buy_more_user_path(:id => @user.uuid) }
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:payment_method, :price, :status)
  end
end
