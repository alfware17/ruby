$LOAD_PATH << "lib"

# Lade den eigentlichen Time TrackerCode
require "time_tracker"

# Die gesamte Programmfunktionalität steckt in der TimeTracker Klasse.
# Diese soll Ausgaben für den Benutzer auf STDOUT erzeugen.
tt = TimeTracker.new(STDOUT)

# Führe den TimeTracker mit den übergebenen Kommandozeilenargumenten aus.
tt.run(ARGV)


