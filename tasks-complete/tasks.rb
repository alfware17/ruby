require_relative "./lib/task"
require_relative "./lib/task_list"

#ARGV = ["done", "Ordnen"]
#ARGV = ["list"]

pp ARGV.count

case ARGV.shift

when "list"

  tasklist = TaskList.new
  tasklist.load("tasks.txt")
  puts "#{tasklist.count} Aufgaben im System"
  puts "#{tasklist.count_open} offen, #{tasklist.count_completed} erledigt"
  tasklist.druck_liste_offen
  tasklist.druck_liste_erledigt

when "done"

  tasklist = TaskList.from_file "tasks.txt"
 
  aufgabe = ""
  aufgabe = ARGV[0] if ARGV.count > 0
  task = tasklist.finde(aufgabe)

  if task
    task.complete!
    ergebnis = aufgabe + " erledigt."
    if tasklist.count_open > 0
      ergebnis += " Noch #{tasklist.count_open} Aufgaben offen."
    end
  else    
    ergebnis = "Nichts zu erledigen."
  end 
 
  puts ergebnis
  tasklist.save("tasks.txt")

when "add"
  tasklist = TaskList.from_file "tasks.txt"

  tasklist << Task.new(ARGV.first, Time.now)

  tasklist.save "tasks.txt"

else
  puts "Usage: tasklist list"
  puts "       tasklist done aufgabe"
  puts "       tasklist add aufgabe"
  
end
