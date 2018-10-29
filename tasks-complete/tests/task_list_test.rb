require "task_list"

class TaskListTest < Minitest::Test
  def setup
    @list = TaskList.new
  end

  def test_tasks_can_be_counted
    assert_equal 0, @list.count
    @list << Task.new("Chaos", Time.new(2018, 10, 1))
    assert_equal 1, @list.count
  end
end

