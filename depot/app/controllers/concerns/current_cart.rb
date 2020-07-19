module CurrentCart
  
  # private 可避免 rails 把下面方法当做控制器动作
  private
    
    def set_cart
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id 
    end

end