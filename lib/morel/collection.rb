# encoding: utf-8

module Morel
  class Collection

    attr_accessor :name, :collection

    def initialize name
      @name = name
      @collection = db.create_collection(name)
    end
    
    def db
      @@db
    end
    def self.db= db
      @@db = db
    end
    
    def delete
      db.drop_collection(name)
    end
    
    def first
      find_one
    end

    def last
      find_one(nil,:sort => [:_id, :desc])
    end
    
    def find args
      map = Ruby2Js.new.process(args[:query].to_code(@collection)) #.gsub(/window\(\)/,'window').gsub(/Node\(k, v\){/,'function Node(k, v){').gsub(/:max/,'max')
      #@collection.db.add_stored_function('foobar',"#{map};")
      #map = "foobar(this);"
      reduce = "function(k,vals){ return 1; }"
      testing = @collection.map_reduce(map, reduce, :out => 'testing')
      testing.find.map{ |m| yield m; m }
    end
    
    OPERATIONS = [
      :insert,
      :find_one,
      :map_reduce
    ]

    OPERATIONS.each do |name|
      class_eval <<-EOS, __FILE__, __LINE__
        def #{name}(*args)
          collection.#{name}(*args)
        end
      EOS
    end

  end
end
