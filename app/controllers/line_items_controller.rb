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
      format.json { render json: @line_item }
    end
  end
  
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
  # old create: def create
  # old create:     @cart = current_cart
  # old create:     product = Product.find(params[:product_id])
  # old create:     @line_item = @cart.add_product(product.id)
    
    # re-factored into cart model: @line_item = @cart.line_items.build(product: product)
    # before: @line_item = LineItem.new(params[:line_item])
  # old create:     session[:counter] = 0

  # old create:     respond_to do |format|
  # old create:       if @line_item.save
  # old create:         # before format.html { redirect_to @line_item, notice: 'Line item was successfully created.' }
  # old create:         format.html { redirect_to @line_item.cart }
  # old create:         format.json { render json: @line_item, status: :created, location: @line_item }
  # old create:       else
  # old create:         format.html { render action: "new" }
  # old create:         format.json { render json: @line_item.errors, status: :unprocessable_entity }
  # old create:       end
  # old create:     end
  # old create:   end
  
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id, product.price)
    
    # re-factored into cart model: @line_item = @cart.line_items.build(product: product)
    # before: @line_item = LineItem.new(params[:line_item])
    session[:counter] = 0
    
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to(@line_item.cart) }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render :action => "new" }
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
  
end
