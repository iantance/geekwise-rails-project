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

context "before save" do
  context "create tags from tag list" do
    setup do
      @user = Fabricate.build(:link, :tag_list => "one two")
    end
    context "tag already exits" do
      setup do
        @tag = Fabricate(:tag, :tag => "one")
      end
      should "add tag to user without creating new tag instance" do
        assert_difference "Tag.count", 1 do
          @user.save
          assert @user.tags.any?
        end
      end
    end
    context "new tag" do
      should "create tag and add to user" do
        assert_difference "Tag.count", 2 do
          @user.save
          assert @user.tags.any?
        end
      end
    end
  end
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
