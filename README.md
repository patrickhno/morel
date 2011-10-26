# Morel

Morel is a mongodb JavaScript AST manager for Ruby.

Currently work in progress and not usefull to anyone.

## Example

``` ruby
[1,2,3,4,5,1,2,3,4,5,6,1,2,3,4,5,6,7].each do |v|
  @users.insert :vol => v
end

res = @users.sorted_window(5){ |record| record['vol'] }.each_top do |rec|
  rec
end

res.map{ |m| m['value'] }
# => [6,6,7]
```

## License

(The MIT License)

Copyright (c) 2011 Patrick Hanevold

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
