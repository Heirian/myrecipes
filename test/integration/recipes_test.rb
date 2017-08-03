require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @user = Chef.create!(chefname: "Heirian", email: "heirian@gabirus.com")
    @recipe = @user.recipes.create(name: "Xurupita", description: "bla bla bla Xurupata")
    @recipe2 = Recipe.create(name: "Carniça", description: "Bla bla bla bla", chef: @user)
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes list" do
    get recipes_url
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
