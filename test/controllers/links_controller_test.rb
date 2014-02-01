require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  context "GET #index" do
    setup do
      get :index
    end

    should respond_with(200)
    should render_template("index")
    should "assign value to links" do
      assert_not_nil :links
    end
  end

  context "GET #new" do
    context "if user logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        get :new
      end
      should render_template("new")

    end

    context "if user not logged in" do
      setup do
        get :new
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end

  context "POST #create" do
    context "if user not logged in" do
      setup do
        post :create, :link => { :link_url => "foo" }
      end
      should "redict to login" do
        assert_redirected_to new_session_url
      end
    end

    context "if user logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
      end
      context "with valid input" do
        setup do
          @link_params = Fabricate.attributes_for(:link)
          post :create, :link => @link_params
        end
        should "save link belonging to user" do
          assert @user.links.any?
        end
        should "redict to links with a flash" do
          assert_not_nil flash[:notice]
          assert_redirected_to links_url
        end
      end

      context "with invalid input" do
        setup do
          post :create, :link => { :link_url => "" }
        end
        should render_template("new")
      end
    end
  end
end







