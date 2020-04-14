class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
  end

  def new
    @merchant = current_user.merchant
    @item = Item.new
  end

  def create
    @merchant = current_user.merchant
    @item = @merchant.items.create(item_params)
    @item.save ? flash_and_redirect(@item) : sad_path(@item)
  end

  def edit
    @item = current_user.merchant.items.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params.include?(:active?)
      @item.update(update_status)
      flash_and_redirect(@item)
    else
      @item.update(item_params)
      if @item.save
        flash[:notice] = "Item with ID: #{@item.id} has been updated"
        redirect_to '/merchant/items'
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash_and_redirect(item)
  end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end

  def update_status
    params.permit(:active?)
  end

  def flash_and_redirect(item)
    flash[:notice] = "#{item.name} is no longer for sale" if !item.active? && params[:action] == "update"
    flash[:notice] = "#{item.name} is now available for sale" if item.active? && params[:action] == "update"
    flash[:notice] = "#{item.name} has been deleted" if params[:action] == "destroy"
    flash[:notice] = "#{item.name} has been saved" if params[:action] == "create"
    redirect_to '/merchant/items'
  end

  def sad_path(item)
    flash[:error] = item.errors.full_messages.to_sentence
    render :new
  end


end
