require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  context "POST #create" do
    context "if user not signed in" do
      setup do
        post :create, :comment => { :text => "foo"}
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end

    context "if user signed in" do
      setup do
        @user = Fabricate(:user)
        @user2 = Fabricate(:user)
        login_as(@user)
        @link = Fabricate(:link, :user_id => @user2.id)
      end
      context "with valid input" do
        setup do
          @comment_params = Fabricate.attributes_for(:comment, :link_id => @link.id)
          post :create, :comment => @comment_params
        end
        should "save comment belonging to user" do
          assert @user.comments.any?
        end
        should "save comment belonging to link" do
          assert @link.comments.any?
        end
        should "redirect to link with a flash" do
          assert_not_nil flash[:notice]
          assert_redirected_to link_url(@link.id)
        end
      end

      context "with invalid input" do
        setup do
          @comment_params = Fabricate.attributes_for(:comment, :link_id => @link.id, :text => "")
          post :create, :comment => @comment_params
        end
        should "redirect to link" do
          assert_redirected_to link_url(@link.id)
        end
      end
    end
  end

  context "POST #upvote" do
    context "if user logged in" do
      setup do
        request.env['HTTP_REFERER'] = "request_origin"
        @user = Fabricate(:user)
        login_as(@user)
        @comment = Fabricate(:comment)
        post :upvote, :id => @comment.id
      end

      context "comment exits" do
        should "register upvote on link from user" do
          assert_equal 1, @comment.upvotes.size
          assert_equal 1, @user.votes.size
        end
        should "reload page" do
          assert_redirected_to "request_origin"
        end
      end

      context "comment does not exist" do
        should "raise routing error" do
          assert_raises ActionController::RoutingError do
            post :upvote, :id => "-1"
          end
        end
      end
    end

    context "if user not logged in" do
      setup do
        @comment = Fabricate(:link)
        post :upvote, :id => @comment.id
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
        @comment = Fabricate(:comment)
        post :downvote, :id => @comment.id
      end
      
      context "comment exits" do
        should "register upvote on link from user" do
          assert_equal 1, @comment.downvotes.size
          assert_equal 1, @user.votes.size
        end
        should "reload page" do
          assert_redirected_to "request_origin"
        end
      end

      context "comment does not exist" do
        should "raise routing error" do
          assert_raises ActionController::RoutingError do
            post :downvote, :id => "-1"
          end
        end
      end
    end

    context "if user not logged in" do
      setup do
        @comment = Fabricate(:link)
        post :downvote, :id => @comment.id
      end
      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end

end










