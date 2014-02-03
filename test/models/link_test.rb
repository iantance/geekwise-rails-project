require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  should "require a valid url" do
    link = Fabricate.build(:link)
    link.link_url = "foo"
    assert link.invalid?
  end

  should "provide title when title left blank" do
    link = Fabricate.build(:link, :title => nil)
    link.save
    assert_not_nil link.title
  end

  should "provide default score" do
    link = Fabricate(:link, :score => nil)
    assert_not_nil link.score
  end

end
