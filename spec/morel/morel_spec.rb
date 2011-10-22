# encoding: utf-8

require 'spec_helper'

describe Morel::Collection do

  before do
    @users = Morel::Collection.new(:users)
    @users.delete
  end

  it 'should insert into the collection' do
    @users.insert :name => 'Patrick'
    @users.first['name'].should == 'Patrick'
  end

  it 'should sort query window' do
    [1,2,3,4,5,1,2,3,4,5,6,1,2,3,4,5,6,7].each do |v|
      @users.insert :vol => v
    end
    res = @users.sorted_window(5){ |record| record['vol'] }.each_top do |rec|
      rec
    end
    res.map{ |m| m['value'] }.should == [6,6,7]
  end

end
