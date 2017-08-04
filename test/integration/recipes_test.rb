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
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get recipe show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @user.chefname, response.body
  end

  test "create new valide recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "chicken"
    description_of_recipe = "comidona gostosa do carambs carai"
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid submissions" do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: " ", description: " " } }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
