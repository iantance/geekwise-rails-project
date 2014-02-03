require 'acts_as_votable'

class Link < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  has_many :comments
  
  URL_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  validates :link_url, :format => URL_REGEX


  attr_accessor :link_domain

  before_save :provide_title
  before_save :default_score

  def update_score
    s =(self.upvotes.size - self.downvotes.size)
    if s > 0 
      sign = 1
    else
      if s < 0
        sign = -1
      else
        sign = 0
      end
    end
    order = Math.log10([0, s.abs].max)
    seconds = created_at.to_i - 1134028003
    score = order + sign * seconds/45000
    self.update_attributes(:score => score)
  end

private
  def default_score
    self.score = self.score || 0
  end

  def provide_title
    self.title = "Link to #{self.link_url}" unless title.present?
  end


end
