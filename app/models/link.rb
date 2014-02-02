class Link < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  URL_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  validates :link_url, :format => URL_REGEX

  attr_accessor :link_domain

  before_save :provide_title

private

  def provide_title
    self.title = "Link to #{self.link_url}" unless title.present?
  end

end
