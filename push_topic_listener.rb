#!/usr/bin/env ruby

push_topic_name = ARGV[0]
replay_from_message = ARGV[1]

if push_topic_name.nil?
  puts 'Please specify a push topic name as the first argument.'
  exit 1
end

require 'rubygems'
require 'bundler/setup'
require 'dotenv'

# load sensitive information from .env file
Dotenv.load

# see https://github.com/ejholmes/restforce#streaming

# Restforce uses faye as the underlying implementation for CometD.
require 'faye'
require 'restforce'

Restforce.log = true

# Restforce will log to STDOUT with the `:debug` log level by default, or you
# can set your own logger and log level.
Restforce.configure do |config|
  #config.logger = Logger.new("/tmp/log/restforce.log")
  #config.log_level = :info
end

# Initialize a client with your username/password/oauth token/etc.
client = Restforce.new \
  authentication_callback: Proc.new { |x| puts "Authentication information: #{x}" }

client.authenticate!

# Subscribe to the PushTopic and continually process messages.
EM.run do
  # gracefully shut the program down, when we see ctrl-c
  Signal.trap 'INT' do
    puts "\nCaught interrupt, shutting down gracefully..."
    EM.stop
  end

  puts "Subscribing to: #{push_topic_name}..."

  subscriptions = client.subscribe push_topic_name, replay: replay_from_message do |message|
    puts '======================='
    puts 'A wild message appears!'
    puts message.inspect
    puts '======================='
  end

  push_topic_subscription = subscriptions.first

  push_topic_subscription.callback do
    puts "Successfully subscribed to #{push_topic_name}"
  end

  # error is a https://github.com/faye/faye/blob/master/lib/faye/error.rb
  # see https://github.com/ejholmes/restforce/issues/202
  push_topic_subscription.errback do |error|
    puts "Failed to subscribe to #{push_topic_name}:"
    puts error.inspect
  end
end
