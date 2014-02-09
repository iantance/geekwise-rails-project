require 'acts_as_votable'

class Link < ActiveRecord::Base
  paginates_per 25
  acts_as_votable
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags

  URL_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  validates :link_url, :format => URL_REGEX


  attr_accessor :link_domain
  attr_accessor :tag_list

  before_save :provide_title
  before_save :default_score
  before_save :create_links, :if => :tags_update?

  def update_score
    s = (self.upvotes.size - self.downvotes.size)
    sign = s <=> 0  
    order = Math.log10([0, s.abs].max)
    seconds = created_at.to_i - 1134028003
    score = order + sign * seconds/45000.0
    self.update_attributes(:score => score)
  end

private

  def create_links
    return unless tag_list
    tag_list.split(%r{,\s*|\s+}).each do |tag|
      if new_tag = Tag.find_by(:tag => tag)
        add_tag = new_tag
      else
        add_tag = Tag.create(:tag => tag)
      end
      self.tags << add_tag
    end
  end

  def tags_update?
    tag_list.present? || new_record?
  end

  def default_score
    self.score = self.score || 0
  end

  def provide_title
    self.title = "Link to #{self.link_url}" unless title.present?
  end


end
