require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: "Heirian", email: "heirian@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "name should be less than 30" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email shouldn't be too long" do
    @chef.email = "a" * 245 + "@example.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com Heirian@gmail.com m.first@yahoo.ca john+car@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "should reject invalid emails" do
    invalid_emails = %w[user@examplecom Heirian.gmail.com m.first.nh@2+22.ca ....\.+@co.uk.org]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end

  test "email should be uniq and case insensitive" do
      duplicate_chef = @chef.dup
      duplicate_chef.email = @chef.email.upcase
      @chef.save
      assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting database" do
    mixed_email = "JoHn@ExAmplE.cOm"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "password should be atleast 5 charactes" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

  test "password should be less than or equal to 72 charactes" do
    @chef.password = @chef.password_confirmation = "x" * 73
    assert_not @chef.valid?
  end
end
