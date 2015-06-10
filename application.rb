# usage:
#  $ ruby application.rb

# adding ./lib to $LOAD_PATH
pwd = File.expand_path("../", __FILE__)
$:.unshift "#{pwd}/lib"

# requiring lib
Dir[File.expand_path("../lib/**/*.rb", __FILE__)].each { |f| require f }

class Application
  def self.run
    100.times { puts User.new.to_insert_sql }
  end
end


Application.run
