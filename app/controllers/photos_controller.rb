class PhotosController < ApplicationController

  def new
    @photo = Photo.new
  end

  def create
    puts params
    restaurant = Restaurant.find_or_create_by(name: params[:photo][:restaurant])
    puts restaurant.id
    @photo = current_user.photos.new(image: photo_params[:image], dish_name: photo_params[:dish_name], lat: photo_params[:lat].to_f, lng: photo_params[:lng].to_f, restaurant: restaurant)
      # byebug

    if @photo.save!
      @photo.pricetag = Pricetag.find_by(price: params[:photo][:pricetag])
      @photo.associate_to_foodtags(foodtag_params[:foodtags].split(","))
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def show
    @photo = Photo.find(params[:id])
    render json: @photo.to_json(methods: [:image_url], :include => { :foodtags => {:only => :description}, :pricetag => {:only => :price}})
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :dish_name, :lat, :lng)
  end

  def foodtag_params
    params.require(:photo).permit(:foodtags)
  end

end
