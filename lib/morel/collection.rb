
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
