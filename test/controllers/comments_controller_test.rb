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
        session[:link_id] = @link.id
      end
      context "with valid input" do
        setup do
          @comment_params = Fabricate.attributes_for(:comment)
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
          post :create, :comment => { :text => "" }
        end
        should "redirect to link" do
          assert_redirected_to link_url(@link.id)
        end
      end
    end
  end
end
