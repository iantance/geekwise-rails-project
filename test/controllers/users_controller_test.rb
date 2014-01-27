require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "GET #new" do
    setup do
      get :new
    end
    should respond_with(200)
    should render_template("new")
  end

  context "POST #create" do
    context "with valid input" do
      setup do
        @user_params = Fabricate.attributes_for(:user)
      end
      should "save new user and redirect with a flash" do
          assert_difference("User.count") do
            post :create, :user => @user_params
          end
          assert_redirected_to(links_url)
          assert_not_nil(flash[:notice])
      end
    end

    context "with invalid input" do
      setup do
        post :create, :user => {:email => "foo"}
      end
      should render_template("new")
    end
  end
end
