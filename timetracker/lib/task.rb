require "time"

class Task
  def self.parse(line)
    text, start, stop, taglist = line.strip.split(",")

    new text,
        Time.parse(start.to_s),
        parse_optional_time(stop),
        taglist: taglist
  end

  def self.parse_optional_time(str)
    Time.parse str.to_s
    rescue ArgumentError
    nil
  end

  attr_reader :text, :start_time, :end_time, :taglist
  attr_accessor :auswahl

  def initialize(text, start_time, end_time = nil, taglist: nil)
    @text = text
    @taglist = taglist
    if taglist
      @tags = taglist.strip.gsub(",","").split(" ")
    else
      @tags = []
    end
    @start_time = start_time
    @end_time = end_time
    @auswahl = true
  end

  def open?
    !completed? && auswahl
  end

  def completed? 
    @end_time && auswahl
  end

  def complete!
    @end_time = Time.new
  end

  def duration
    if completed?
      (end_time - start_time).to_i
    else
      0
    end
  end

  def tags
    @tags
  end

  def tags_liste
    tags.join(" ")
  end

  def tags_liste_druck
    "(" + tags.join(", ") +")" if tags.length > 0
  end

  def to_s
    [text, start_time, end_time, tags_liste].join(",")
  end
end


