# encoding: utf-8

module Morel

  class Collection
    def sorted_window size, &block
      SortedWindow.new(:collection => self, :size => size, :block => block)
    end
  end

  class SortedWindow    
    
    # this code will be translated to javascript
    @@code = lambda do |collection|
      lambda{ |k,v|
        unless window
          # list node for our linked list of key value pairs
          def Node k,v
            @next = nil
            @prev = nil
            @k    = k
            @v    = v
          end

          window = {
            last: nil,
            list: [],  # all the nodes sorted

            # search for a given key value pair
            find: lambda{ |k,v|
              # first search for the key
              beg = 0
              lst = @list[:length]-1
              mid = (beg+lst)>>1
              while true
                if k<@list[mid][:k]
                  lst=mid
                else
                  beg=mid
                end
                mid = (beg+lst)>>1
                break if mid==beg
              end

              # may not be exact match (multiple of same key value), searh in both directions for a exact match
              start = mid
              dir = 1
              while v != @list[mid][:v]
                mid += dir
                if mid == @list[:length]
                  # end reached, flip direction and start over
                  mid = start
                  dir =- 1
                end
              end

              # found
              return mid
            },

            # add a new key value pair to the window (its linked list)
            add: lambda{ |k,v|
              if @list[:length]
                beg = 0
                lst = @list[:length]-1
                mid = (beg+lst)>>1

                # just add it to the end of our linked list
                n = Node.new(k,v)
                @last.next = n
                n.prev = @last
                @last = n


                # and insert it at the correct place in our sorted list
                if k>=@list[lst][:k]
                  if @list[:length] == :max && k>@list[lst][:k]
                    emit(n[:v][:_id],n[:v][:vol])
                  end
                  @list.push(n)
                else
                  while true
                    if k<@list[mid][:k]
                      lst=mid
                    else
                      beg=mid
                    end
                    mid = (beg+lst)>>1
                    break if mid==beg
                  end

                  if k<@list[mid][:k]
#                    if @list[:length] >= :max && mid==0
                  #    # we got a new winner, so anounce it
                  #    #print(tojson(this.list[mid].v));
#                      emit(@list[mid][:k],@list[mid][:v])
#emit(@list[mid][:v][:_id],@list[mid][:v][:vol])
#                    end
                    @list.splice(mid,0,n)
                  elsif k<@list[lst][:k]
                    @list.splice(lst,0,n)
                  else
                    #print("!!!");
                    #print(k);
                    #print(this.list[mid].k);
                    #print(this.list[end].k);
                    while true
                    end
                  end
                end

                # dont let the window grow larger then its size
                if @list[:length] > :max
                  # remove first
                  @list.splice(this.find(@first[:k],@first[:v]),1)
                  @first[:next].prev = nil
                  @first = @first[:next]
                end
              else
                # the list is empty, just push it
                @last = Node.new(k,v)
                @first = @last
                @list.push(@last)
              end
            }
          }
        end
        window.add(v[:vol],v)
      }
    end

    def initialize params
      @collection = params[:collection]
      @size       = params[:size]
      @block      = params[:block]
    end

    def each_top
      unless @map
        @map = Ruby2Js.new.process(@@code.to_code(@collection)).gsub(/window\(\)/,'window').gsub(/Node\(k, v\){/,'function Node(k, v){').gsub(/:max/,'max')
        @collection.db.add_stored_function('hello',@map)
        @map = "hello(this._id,this);"
      end
      reduce = "function(k,vals){ return 1; }"
      testing = @collection.collection.map_reduce(@map, reduce, :out => 'testing', :scope => { :window => nil, :max => @size }) #, :out => "testing", :query => { :user => user })
      testing.find.map{ |m| yield m; m }
    end
    
  end

end
