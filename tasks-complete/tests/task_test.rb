require "task"

class TaskTest < Minitest::Test
  def test_completed_with_end_date
    task = Task.new("Chaos", Time.new(2018, 1, 1))

    refute task.completed?
    
    task.complete!
    assert task.completed?
  end
end
