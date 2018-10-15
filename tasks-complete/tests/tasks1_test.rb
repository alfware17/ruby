require_relative "../tasks"

class TaskTest1 < Minitest::Test
  def test_1
    tasks "list"
  end
end

