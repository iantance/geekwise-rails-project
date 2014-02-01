require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "GET #show" do
    context "if user exists" do
      setup do
        @user = Fabricate(:user)
        get :show, :name => @user.name
      end
      should render_template("show")
      should "assign the user" do
        assert_equal @user, assigns(:user)
      end
    end

    context "if user does not exist" do
      should "raise a routing error" do
        assert_raises(ActionController::RoutingError) do
          get :show, :name => "foo"
        end 
      end
    end

  end

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

  context "GET #edit" do
    context "if user logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        get :edit
      end
      should render_template("edit")
    end

    context "if user not logged in" do
      setup do
        get :edit
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end

  context "PUT #update" do
    context "if user not logged in" do
      setup do
        put :update, {:email => "foo"}
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end

    context "if user logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
      end
      context "with valid credentials" do
        setup do
        @user_params = Fabricate.attributes_for(:user)
        put :update, :user => @user_params
        @user.reload
        end
        should "save user changes" do
          assert_equal @user_params[:email], @user.email
        end
        should "redirect with a flash notice" do
          assert_equal "Settings saved", flash[:notice]
          assert_redirected_to edit_user_url
        end
      end

      context "with invalid credentials" do
        setup do
          put :update, :user => { :email => "foo" }
        end
        should render_template("edit")
      end
    end
  end
end




