$LOAD_PATH << File.expand_path("../lib", __dir__)

require "tempfile"

require "minitest/autorun"

require "time_tracker"

class TimeTrackerTest < Minitest::Test
  def setup
    @out = StringIO.new
    @tmpfile = Tempfile.new 'tasks.txt'

    # Squiggly heredoc entfernt Leerzeichen am Zeilenanfang (unindent)
    @tmpfile.write <<~TASKS
      Hausaufgaben erledigen,2018-09-18 22:30:00 +0200,,ruby2018 openhpi
      Bug finden,2018-09-16 18:10:00 +0200,,openhpi entwicklung
      Software installieren,2018-09-16 14:14:00 +0200,2018-09-17 16:02:00 +0200,openhpi entwicklung
      Video aufnehmen,2018-09-20 12:00:00 +0200,2018-09-25 09:00:00 +0200,openhpi ruby2018
      Büropflanze gießen,2018-02-05 09:30:00 +0200,,büro
      Dokumentation schreiben,2018-06-10 15:56:00 +0200,2018-08-28 21:20:00 +0200,entwicklung hobby
    TASKS

    # Speicher Inhalte sicher auf Platte, damit TimeTracker die lesen kann
    @tmpfile.flush

    # Benutzte eigene Tasks-Datei nur für Tests
    @tt  = TimeTracker.new @out, filename: @tmpfile.path
  end

  def test_cmd_list
    @tt.run(['list'])

    assert_equal <<~AUSGABE, @out.string
      Noch 3 offene Aufgabe(n):

      OFFEN seit 2018-02-05 09:30:00 +0200: Büropflanze gießen (büro)
      OFFEN seit 2018-09-16 18:10:00 +0200: Bug finden (openhpi entwicklung)
      OFFEN seit 2018-09-18 22:30:00 +0200: Hausaufgaben erledigen (ruby2018 openhpi)

      Fertig seit 2018-09-25 09:00:00 +0200: Video aufnehmen (openhpi ruby2018)
      Fertig seit 2018-09-17 16:02:00 +0200: Software installieren (openhpi entwicklung)
      Fertig seit 2018-08-28 21:20:00 +0200: Dokumentation schreiben (entwicklung hobby)
    AUSGABE
  end

  def test_cmd_list_all_completed
    File.write @tmpfile.path, <<~TASKS
      Software installieren,2018-09-16 14:14:00 +0200,2018-09-17 16:02:00 +0200,openhpi entwicklung
      Video aufnehmen,2018-09-20 12:00:00 +0200,2018-09-25 09:00:00 +0200,openhpi ruby2018
      Dokumentation schreiben,2018-06-10 15:56:00 +0200,2018-08-28 21:20:00 +0200,entwicklung hobby
    TASKS

    @tt.run(['list'])

    assert_equal <<~AUSGABE, @out.string
      Keine offenen Aufgaben.

      Fertig seit 2018-09-25 09:00:00 +0200: Video aufnehmen (openhpi ruby2018)
      Fertig seit 2018-09-17 16:02:00 +0200: Software installieren (openhpi entwicklung)
      Fertig seit 2018-08-28 21:20:00 +0200: Dokumentation schreiben (entwicklung hobby)
    AUSGABE
  end

  def test_cmd_done
    @tt.run(['done', 'Büropflanze gießen'])

    assert_equal <<~AUSGABE, @out.string
      Aufgabe erledigt: Büropflanze gießen
      Noch 2 Aufgaben offen.
    AUSGABE
  end
end

