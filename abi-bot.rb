#!/usr/bin/env ruby

require './lib/console.rb'

console = Console.new
bot = Bot.new(console.get_token)
