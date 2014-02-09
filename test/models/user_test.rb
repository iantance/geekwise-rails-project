require 'test_helper'

class UserTest < ActiveSupport::TestCase

  
  context "before save" do
    context "if password is set" do
      setup do
        @user = Fabricate(:user)
        
      end
      should "generate hash and salt" do
        assert @user.password_salt.present?
        assert @user.password_hash.present?
      end
    end
    context "if password is not set" do
      setup do
        @user = Fabricate(:user)
        @hash = @user.password_hash
        @salt = @user.password_salt

        @user.password = nil
        @user.save
      end

      should "not change the salt and hash" do
        assert_equal @hash, @user.password_hash
        assert_equal @salt, @user.password_salt
      end
    end


  end

  context ".authenticate" do
    setup do
      @user = Fabricate(:user)
    end

    should "return false if user does not exist" do
      assert_equal false, User.authenticate("me@example.com", "foo")
    end

    should "return false if user exists and password is wrong" do
      assert_equal false, User.authenticate(@user.email, "wrongpassword")
    end

    should "return the user if user exists and password is correct" do
      assert_equal @user, User.authenticate(@user.email, @user.password)
    end
  end


end










