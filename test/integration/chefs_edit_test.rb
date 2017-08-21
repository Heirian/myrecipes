require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "mashrur",
                         email: "mashrur@example.com",
                         password: "password",
                         password_confirmation: "password")
    @admin_chef = Chef.create!(chefname: "johny",
                               email: "johny@example.com",
                               password: "password",
                               password_confirmation: "password",
                               admin: true)
    @chef2 = Chef.create!(chefname: "john",
                          email: "john@example.com",
                          password: "password",
                          password_confirmation: "password")
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "heirian@example.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "heirian noonan", email: "heiriann@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "heirian noonan", @chef.chefname
    assert_match "heiriann@example.com", @chef.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "heirian noonan2", email: "heiriann2@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "heirian noonan2", @chef.chefname
    assert_match "heiriann2@example.com", @chef.email
  end

  test "redirect edit attempt by other no-admin user" do
    sign_in_as(@chef2, "password")
    patch chef_path(@chef), params: { chef: { chefname: "joe", email: "joe@example.com" } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "mashrur", @chef.chefname
    assert_match "mashrur@example.com", @chef.email
  end
end
