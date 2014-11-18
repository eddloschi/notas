require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "deve ter texto" do
    n = notes(:one)
    n.body = nil
    assert_not n.save
  end

  test "deve ter uma cor válida" do
    n = notes(:one)
    n.color = "Black"
    assert_not n.save
  end
end
