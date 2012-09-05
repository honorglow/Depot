class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @line_item }
    end
    rescue ActiveRecord::RecordNotFound
      # CarlosR implementation:  http://pragprog.com/wikis/wiki/Pt-E-3
      logger.error "Attempt to access invalid line_item #{ params[ :id ]}" 
      redirect_to store_url, :notice => 'Invalid line item'
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end
  
  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id, product.price)
    
    # re-factored into cart model: @line_item = @cart.line_items.build(product: product)
    # before: @line_item = LineItem.new(params[:line_item])
    session[:counter] = 0
    
    respond_to do |format|
      if @line_item.save
        # old non-ajax: format.html { redirect_to(@line_item.cart) }
        format.html { redirect_to store_url }
        format.js { @current_item = @line_item }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      # Sergey implementation: http://pragprog.com/wikis/wiki/Pt-E-4
      # not working format.html { redirect_to current_cart }  
      # not working format.json { head :no_content }
      format.html { redirect_to(@line_item.cart, :notice => 'Item has been removed from your cart.') }
      format.json  { head :ok }
    end
  end
  
  # PUT /line_items/1
  # PUT /line_items/1.json
  def decrement
    @cart = current_cart

    # 1st way: decrement through method in @cart
    logger.info "WE GET HERE"
    @line_item = @cart.decrement_line_item_quantity(params[:id]) # passing in line_item.id

    # 2nd way: decrement through method in @line_item
    #@line_item = @cart.line_items.find_by_id(params[:id])
    #@line_item = @line_item.decrement_quantity(@line_item.id)
    
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js {@current_item = @line_item}
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
