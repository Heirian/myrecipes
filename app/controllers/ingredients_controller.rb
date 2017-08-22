class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end

  def show
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
  end

  def edit
  end

  def update
  end

end
