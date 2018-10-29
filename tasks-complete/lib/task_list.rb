#require "task"

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

  def save2(filename)
    File.write(filename, map(&:to_s).join)
  end

  def save(filename)
    File.open(filename, "w") do |file|
      @tasks.each do |t| 
        file.puts "#{t.text},#{t.start_time},#{t.end_time}"
      end
    end
  end

  include Enumerable

  def each
    @tasks.each { |t| yield t }
  end

  def <<(task)
    @tasks << task
    self
  end
  
  def count_open
    @tasks.select {|t| !t.completed?}.count
  end

  def count_completed
    @tasks.select {|t| t.completed?}.count
  end
  
  def druck_liste (sublist)
    sublist.each do |t| 
      puts t.druck
    end
  end
  
  def druck_liste_offen
    druck_liste(@tasks.select {|t| !t.completed?})
  end

  def druck_liste_erledigt
    druck_liste(@tasks.select {|t| t.completed?})
  end

  def finde_offen(text)
    @tasks.select{|t| !t.completed? and t.text == text}.first
  end
  
  def finde(text)
    @tasks.select{|t| t.text == text}.first
  end

  def entferne(task)
    neu=TaskList.new
    self.each do |t|
      neu << t if !t.eql?(task)
    end
    neu
  end
end

