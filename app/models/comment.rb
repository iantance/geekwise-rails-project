require 'acts_as_votable'
require 'ancestry'

class Comment < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  belongs_to :link
  has_ancestry
  validates :text, :presence => true

  default_scope -> { order('score DESC') }

  before_save :default_score

  @@lock = Mutex.new

  @@score_results = {}

  def update_score
    @@lock.synchronize do
      self.update_attributes(:score => confidence_score(ups, downs))
    end
  end

private

  def confidence_score(ups, downs)
    return @@score_results[[ups, downs]] unless @@score_results[[ups, downs]].nil?
    return 0 unless ups + downs > 0
    z = 1.6
    phat = ups/sample
    @@score_results[[ups, downs]] = Math.sqrt(phat+z*z/(2*sample)-z*((phat*(1-phat)+z*z/(4*sample))/sample))/(1+z*z/sample)
  end

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
