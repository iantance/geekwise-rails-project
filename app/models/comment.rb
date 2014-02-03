require 'acts_as_votable'

class Comment < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :link
  validates :text, :presence => true

  default_scope -> { order('created_at DESC') }
end
