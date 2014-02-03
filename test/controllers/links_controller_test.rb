require 'test_helper'

class LinksControllerTest < ActionController::TestCase

  context "GET #show" do
    context "if link exists" do
      setup do
        @user = Fabricate(:user)
        @link = Fabricate(:link, :user_id => @user.id)
        get :show, :id => @link.id
      end
      should render_template("show")
      should "assign link" do
        assert_equal @link, assigns(:link)
      end
    end  

    context "if link does not exist" do
      should "raise routing error" do
        assert_raises ActionController::RoutingError do
          get :show, :id => "-1"
        end
      end
    end
  end


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

  context "GET #newest" do
    setup do
      get :newest
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

  context "POST #upvote" do
    context "if user logged in" do
      setup do
        request.env['HTTP_REFERER'] = "request_origin"
        @user = Fabricate(:user)
        login_as(@user)
        @link = Fabricate(:link)
        post :upvote, :id => @link.id
      end

      context "link exits" do
        should "register upvote on link from user" do
          assert_equal 1, @link.upvotes.size
          assert_equal 1, @user.votes.size
        end
        should "reload page" do
          assert_redirected_to "request_origin"
        end
      end

      context "link does not exist" do
        should "raise routing error" do
          assert_raises ActionController::RoutingError do
            post :upvote, :id => "-1"
          end
        end
      end
    end

    context "if user not logged in" do
      setup do
        @link = Fabricate(:link)
        post :upvote, :id => @link.id
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end

  context "POST #downvote" do
    context "if user logged in" do
      setup do
        request.env['HTTP_REFERER'] = "request_origin"
        @user = Fabricate(:user)
        login_as(@user)
        @link = Fabricate(:link)
        post :downvote, :id => @link.id
      end
      
      context "link exits" do
        should "register upvote on link from user" do
          assert_equal 1, @link.downvotes.size
          assert_equal 1, @user.votes.size
        end
        should "reload page" do
          assert_redirected_to "request_origin"
        end
      end

      context "link does not exist" do
        should "raise routing error" do
          assert_raises ActionController::RoutingError do
            post :downvote, :id => "-1"
          end
        end
      end
    end

    context "if user not logged in" do
      setup do
        @link = Fabricate(:link)
        post :downvote, :id => @link.id
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end
end







