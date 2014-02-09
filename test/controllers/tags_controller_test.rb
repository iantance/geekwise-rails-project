require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  context "GET #show" do
    context "no links with that tag" do
      setup do
        get :show, :tag => "foo", :page => 1
      end
      should "redirect to links with flash" do
        assert_not_nil flash[:notice]
        assert_redirected_to links_url
      end
    end
    context "links with that tag exit" do
      setup do 
        @user = Fabricate(:user)
        @link = Fabricate(:link, :tag_list => "cool", :user_id => @user.id)
        get :show, :tag => "cool"
      end
      should respond_with(200)
      should "assign value to links" do
        assert_not_nil :links
      end
    end
  end
end


