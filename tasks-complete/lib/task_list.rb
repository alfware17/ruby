require "task"

class TaskList
  def initialize(tasks = [])
    @tasks = tasks
  end

  def self.from_file(filename)
    instance = new
    instance.load(filename)
    instance
  end

  def load(filename)
    File.open(filename, "r") do |file|
      file.each do |line|
        self << Task.parse(line)
      end
    end
  end

  def save(filename)
    File.write(
      filename,
      map(&:to_s).join
    )
  end

  include Enumerable

  def each
    @tasks.each { |t| yield t }
  end

  def <<(task)
    @tasks << task
    self
  end
end
