class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :link
  validates :text, :presence => true
end
