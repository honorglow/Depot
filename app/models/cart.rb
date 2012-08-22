class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
    
  # old v.: def add_product(product_id)
  # old v.:   current_item = line_items.find_by_product_id(product_id)
  # old v.:   
  # old v.:   if current_item
  # old v.:     current_item.quantity += 1
  # old v.:   else
  # old v.:     current_item = line_items.build(product_id: product_id)  
  # old v.:   end
  # old v.:    
  # old v.:    current_item
  # old v.:  end  
  
  def add_product(product_id, product_price)
    current_item = line_items.where(:product_id => product_id).first
    
    if current_item
      current_item.quantity += 1
    else
      current_item = LineItem.new(:product_id => product_id, :price => product_price)
      line_items << current_item
    end
    current_item
  end
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end  
  
  
end
