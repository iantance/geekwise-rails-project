module CommentsHelper
  def nested_comments(comments)
    comments.map do |comment, sub_comment|
      render(comment) + content_tag(:ol, nested_comments(sub_comment), :class => "nested_comments")
    end.join.html_safe
  end
end
