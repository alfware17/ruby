# lib/cli.rb
require "task_list"

class CLI
  def initialize(out)
    @out = out
  end

  def tasklist
    @tasklist ||= TaskList.from_file("tasks.txt")
  end

  def run(argv)
    case argv.shift
    when "list"
      run_list
    when "done"
      run_done(argv)
    # ...
    end
  end

  def run_list
    @out.puts "#{tasklist.count} Aufgaben im System"
    @out.puts "#{tasklist.count_open} offen, #{tasklist.count_completed} erledigt"
    tasklist.druck_liste_offen(@out)
    tasklist.druck_liste_erledigt(@out)
  end
end
