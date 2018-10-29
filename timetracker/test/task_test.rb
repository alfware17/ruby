$LOAD_PATH << File.expand_path("../lib", __dir__)

require "minitest/autorun"

require "task"

class TaskTest < Minitest::Test
  def test_class_parse
    task = Task.parse("Task Text,2018-10-04 19:15:00 +0200,,")
    assert_equal "Task Text", task.text
    assert_equal Time.new(2018, 10, 4, 19, 15, 0, "+02:00"), task.start_time
  end

  def test_class_parse_end_time
    task = Task.parse("Task Text,2018-10-04 19:15:00 +0200,2018-10-06 09:45:00 +0200,")
    assert_equal Time.new(2018, 10, 6, 9, 45, 0, "+02:00"), task.end_time
  end

  def test_class_parse_tag
    task = Task.parse("Task Text,2018-10-04 19:15:00 +0200,,ruby2018")
    assert_equal "ruby2018", task.tag
  end
end

