# PushTopic Streaming

This repo provides a script that, when run, will allow you to subscribe to a given Salesforce PushTopic and print out events. It also tests preliminary support of [replaying events using Restforce](https://github.com/ejholmes/restforce/pull/265).

## Setup

Change your `.env` file to contain the right Salesforce parameters to get Restforce to be able to authenticate. You will probably need to create a custom app with OAuth permissions in order to be able to do this. You'll also need a PushTopic to subscribe to. You can do this through Restforce, or through the Salesforce UI.

## Useful resources

 - [cometdReplayExtension.js][cometd] (this gave a lot of detail that was useful)
 - [Faye client extensions documentation][faye extensions] (pretty much used this exact template for the extension)
 - [Faye Ruby client example][faye ruby client]

[cometd]: https://github.com/developerforce/StreamingReplayClientExtensions/blob/48ce54bb9ef939ff13c73302a0f33786c5c343f2/javascript/cometdReplayExtension.js
[faye extensions]: https://faye.jcoglan.com/ruby/extensions.html
[faye ruby client]: https://github.com/faye/faye/blob/master/examples/ruby/client.rb
