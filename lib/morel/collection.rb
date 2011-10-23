# encoding: utf-8

module Morel
  class Collection

    attr_accessor :name, :collection

    def initialize name
      if name.kind_of? Mongo::Collection
        @collection = name
      else
        @collection = db.create_collection(name)
      end
    end
    
    def name
      @collection.name
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
      @collection.find_one
    end

    def last
      @collection.find_one(nil,:sort => [:_id, :desc])
    end

    def find(*args,&block)
      args = args.first
      args = {} unless args.kind_of? Hash
      unless block_given?
        @collection.find # returns cursor
      else
        scope = args[:scope] || {}
        map = Ruby2Js.new.process(block.to_code(@collection)).gsub(/window\(\)/,'window').gsub(/Node\(k, v\){/,'function Node(k, v){').gsub(/:max/,'max')
        #@collection.db.add_stored_function('foobar',"#{map};")
        #map = "foobar(this);"
        reduce = "function(k,vals){ return 1; }"
        testing = @collection.map_reduce(map, reduce, :out => 'testing', :scope => scope)
        Collection.new testing
      end
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
