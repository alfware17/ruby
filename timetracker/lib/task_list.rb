require "task"

class TaskList
  def initialize
    @tasks = []
    @plus = []
    @minus = []
  end

  def self.from_file(filename)
    new.tap do |tasklist|
      tasklist.load filename
    end
  end

  def load(filename)
    File.open(filename, "r") do |file|
      file.each do |line|
        self << Task.parse(line)
      end
    end
  end

  def save(filename)
    File.write filename, @tasks.join("\n")
  end

  include Enumerable

  def each
    @tasks.each { |t| yield t }
  end

  def <<(task)
    @tasks << task
    self
  end

  #vergleicht die Listen, ob alle Elemente im :vergleich auch in :liste sind
  def ueberein_alle?(liste, vergleich)
    ergebnis = false
    zaehler = 0
    liste.each do |el| 
      vergleich.each do |vg|
        zaehler += 1 if el == vg
      end
    end
    if zaehler == vergleich.count
      ergebnis = true
    end
    ergebnis
  end

  #vergleicht die Listen, ob sich mindestens eine Übereinstimmung findet
  def ueberein_eine?(liste, vergleich)
    ergebnis = false
    liste.each do |el| 
      vergleich.each do |vg|
        ergebnis = true if el == vg
      end
    end
    ergebnis
  end

  #separiert die Tags nach + und - dabei falsche werden ausgegeben
  def auswerten(*args, out)
    args.each do |a| 
      case a[0]
      when "+"
        @plus << a[1..-1] 
      when "-"
        @minus << a[1..-1] 
      else
        out.puts "Tag ohne +/- ? #{a}" 
      end
    end
    #Für alle Tasks :auswahl ggf. von true (Standard) auf false stellen,
    #:auswahl bleibt true wenn die Liste @plus leer ist und (später) @minus auch
    #:auswahl wird false, wenn NICHT alle Tags aus @plus in task.tags vorkommen
    #:auswahl wird false, wenn ein passendes Tag in @minus gefunden wird
    each do |t|
      t.auswahl = @plus == [] || ueberein_alle?(t.tags, @plus)
      t.auswahl = t.auswahl && !ueberein_eine?(t.tags, @minus)
    end
  end
  
  def finde_offen(text)
    @tasks.select{|t| !t.completed? and t.text == text}.first
  end
  
  def finde(text)
    @tasks.select{|t| t.text == text}.first
  end

  def entferne!(task)
    @tasks = @tasks.reject do |t| t.eql?(task) end
  end

  def entferne(task)
    neu = TaskList.new
    self.each do |t|
      neu << t if !t.eql?(task)
    end
    neu
  end
end

