$LOAD_PATH << File.expand_path("../lib", __dir__)

require "minitest/autorun"

Dir["#{__dir__}/*_test.rb"].each do |f|
	require f
end
