require 'acts_as_votable'

class Comment < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :link
  validates :text, :presence => true
end
