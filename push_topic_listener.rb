#!/usr/bin/env ruby

push_topic_name = ARGV[0]
replay_from_message = ARGV[1]

if push_topic_name.nil?
  puts 'Please specify a push topic name as the first argument.'
  exit 1
end

require 'rubygems'
require 'bundler'
require 'dotenv'

# load sensitive information from .env file
Dotenv.load

# see https://github.com/ejholmes/restforce#streaming

# Restforce uses faye as the underlying implementation for CometD.
require 'faye'
require 'restforce'

# Initialize a client with your username/password/oauth token/etc.
client = Restforce.new
client.authenticate!

# Subscribe to the PushTopic and continually process messages.
EM.run do
  # gracefully shut the program down, when we see ctrl-c
  Signal.trap 'INT' do
    puts "\nCaught interrupt, shutting down gracefully..."
    EM.stop
  end

  puts "Started subscriber for PushTopic: #{push_topic_name}"
  subscriptions = client.subscribe push_topic_name do |message|
    puts '======================='
    puts 'A wild message appears!'
    puts message.inspect
    puts '======================='
  end

  # e is a https://github.com/faye/faye/blob/master/lib/faye/error.rb
  # see https://github.com/ejholmes/restforce/issues/202
  subscriptions.first.errback do |e|
    raise e.message
  end
end
