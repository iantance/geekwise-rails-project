class Link < ActiveRecord::Base
  URL_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  validates :link_url, :format => URL_REGEX
end
