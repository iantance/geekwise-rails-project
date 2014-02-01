require 'test_helper'

class LinksHelperTest < ActionView::TestCase
  context ".link_domain" do
    setup do
      @link = Fabricate(:link, :link_url => "http://www.example.com/testing/testing/123")
    end
    should "parse domain from url" do
      assert_equal "www.example.com", link_domain(@link)
    end
  end

end
