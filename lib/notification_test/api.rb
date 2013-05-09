require 'date'

require 'killbill/notification'

module NotificationTest
  class NotificationPlugin < Killbill::Plugin::Notification


    def start_plugin
      super
    end

    def initialize(*args)
      super(*args)
    end

    def on_event(event)
      @logger.warn "Received #{event.to_s}"
=begin      
      if (event.event_type == 'ACCOUNT_CREATION') 
        @tag_user_api.add_tags() 
      end
=end
    end
  end
end
