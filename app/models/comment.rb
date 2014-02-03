require 'acts_as_votable'

class Comment < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :link
  validates :text, :presence => true

  default_scope -> { order('score DESC') }

  before_save :default_score

  def update_score
    return 0 unless ups + downs > 0
    z = 1.6
    phat = ups/sample
    score = Math.sqrt(phat+z*z/(2*sample)-z*((phat*(1-phat)+z*z/(4*sample))/sample))/(1+z*z/sample)
    self.update_attributes(:score => score)
  end

private
  def default_score
    self.score = self.score || 0
  end

  def ups
    upvotes.size
  end

  def downs
    downvotes.size
  end

  def sample
    ups + downs
  end

end
