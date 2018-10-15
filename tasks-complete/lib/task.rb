# Für Time.parse
require "time"

class Task
  def initialize(text, start_time, end_time = nil, tag: "")
    @text = text
    @start_time = start_time
    @end_time = end_time
    @tag = tag
  end

  def self.parse(line)
    parts = line.strip.split(",")
    new(
      parts[0],
      Time.parse(parts[1]),
      (Time.parse(parts[2]) rescue nil),
      tag: parts[3]
    )
  end

  def to_s
    "#{@text},#{@start_time},#{@end_time},#{@tag}\n"
  end

  attr_reader :text, :tag
  
  def completed?
    !@end_time.nil?
  end

  def complete!
    @end_time = Time.now
  end

  def duration
    return 0 unless completed?

    (@end_time - @start_time).to_i
  end
end
