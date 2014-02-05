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

  context "#update_score" do
    context "different creation times with equal upvotes" do
      setup do
        @user = Fabricate(:user)
        5.times do |i|
          link = Fabricate(:link, :created_at => i.days.ago)
          link.liked_by @user
          link.update_score
        end
      end
      should "give highest score to most recent link" do
        assert_equal Link.all.order("score DESC").to_a, Link.all.order("created_at DESC").to_a
      end
    end

    context "same creation time, different votes" do
      context "more upvotes" do
        setup do
          @link1 = Fabricate(:link, :created_at => Time.new(2014))
          @link2 = Fabricate(:link, :created_at => Time.new(2014))
          @link3 = Fabricate(:link, :created_at => Time.new(2014))
          @link4 = Fabricate(:link, :created_at => Time.new(2014))
          4.times do |i|
            user = Fabricate(:user)
            Link.all.to_a.each do |link|
              link.liked_by user unless link.id < i + 1
              link.update_score
            end
          end         
        end
        should "give highest score to most upvoted" do
          assert_equal Link.all.order("id DESC").to_a, Link.all.order("score DESC").to_a
        end
      end
    end
  end
end
