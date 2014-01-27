require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  should "require a valid url" do
    link = Fabricate.build(:link)
    link.link_url = "foo"
    assert link.invalid?
  end
end
