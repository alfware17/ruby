require "cli"

class CLITest < Minitest::Test
  def setup
    @out = StringIO.new # Ein IO-like Objekt dass alle Ausgaben in einem String speichert
    @cli = CLI.new(@out)
  end

  def test_list
    @cli.run(["tasks", "list"])  # Aufruf als wenn `ruby tasks.rb list` ausgeführt worden wäre
    assert @out.string.include?("Aufgaben im System")
  end
end
