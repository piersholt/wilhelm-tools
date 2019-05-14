# frozen_string_literal: true

module Messaging
  # Comment
  module API
    include LogActually::ErrorOutput
    include Constants
    include Debug
    include Manager
    include Controller

    def thy_will_be_done!(command_topic, command_name, properties = {})
      action = Messaging::Action.new(topic: command_topic, name: command_name, properties: properties)
      fuckin_send_it_lads!(action)
    end

    def fuckin_send_it_lads!(action)
      LogActually.messaging.debug(self.class) { "sending: #{action}"}
      Publisher.send!(action)
    rescue StandardError => e
      with_backtrace(LogActually.messaging, e)
    end

    def so?(command_topic, command_name, properties = {}, callback)
      action = Messaging::Request.new(topic: command_topic, name: command_name, properties: properties)
      request_this(action, callback)
    end

    def request_this(action, callback)
      Client.instance.queue_message(action, callback)
    end
  end
end
