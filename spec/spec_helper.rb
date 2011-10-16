#$LOAD_PATH.unshift(File.dirname(__FILE__))
#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'arel-mongo'
#require 'spec'
#require 'spec/autorun'

require 'mongo'
require 'morel'

RSpec.configure do |config|
  config.before do
    db = ::Mongo::Connection.new('localhost', 27017).db('test')
    Morel::Collection.db = db
  end
end
