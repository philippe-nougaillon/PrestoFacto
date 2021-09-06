require "test_helper"

class BlogTest < ActiveSupport::TestCase

  test "un blog a quelques champs obligatoires" do
    blog = Blog.new
    assert blog.invalid?
    assert blog.errors[:titre].any?
    assert blog.errors[:corps].any?
  end

  test "le blog doit être créé s'il a des attributs valides" do
    blog = blogs(:blog)
    assert blog.valid?
  end
  
end
