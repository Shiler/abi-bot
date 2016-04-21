#!/usr/bin/env ruby
require 'date'
require './lib/console.rb'
require './lib/methods.rb'


require 'colorize'



class Task

attr_accessor :time_of_birthday, :leadtime

def initialize (id=nil, token=nil, leadtime=nil)
  @methods = Methods.new
  @token = Console.new.get_token
  @id = id
  @executed = false
  #@time_helper      =
  @time_of_birthday = "#{Time.now.hour}:#{Time.now.min}"
  @leadtime = leadtime
end


end
