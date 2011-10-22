# encoding: utf-8

require 'mongo'
require 'morel'

RSpec.configure do |config|
  config.before do
    db = ::Mongo::Connection.new('localhost', 27017).db('test')
    Morel::Collection.db = db
  end
end
