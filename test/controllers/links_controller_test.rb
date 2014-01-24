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
end
