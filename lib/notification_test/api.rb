module NotificationTest
  class NotificationPlugin < Killbill::Plugin::Notification

    def on_event(event)
      if event.event_type == :ACCOUNT_CREATION
        write_event :TAG_CREATION, :ACCOUNT, event.object_id, event.account_id, event.tenant_id
      elsif event.event_type == :ACCOUNT_CHANGE
        write_event :TAG_DELETION, :ACCOUNT, event.object_id, event.account_id, event.tenant_id
      else
        @logger.warn "Unexpected event type #{event.event_type} for object #{event.object_type}"
        # Error: unexpected event. Notify the test by sending a bogus event
        write_event :SUBSCRIPTION_UNCANCEL, :SUBSCRIPTION, 'f2e50cd0-faec-11e3-a3ac-0800200c9a66', 'f2e50cd0-faec-11e3-a3ac-0800200c9a66', 'f2e50cd0-faec-11e3-a3ac-0800200c9a66'
      end
    end

    private

    def write_event(event_type, object_type, object_id, account_id, tenant_id)
      file_name = "/var/tmp/killbill-notification-test.txt"
      content   = "#{event_type}-#{object_type}-#{object_id}-#{account_id}-#{tenant_id}"

      # Append the content to make sure we fail in case we receive multiple events
      File.open(file_name, 'a') { |f| f.puts content }
    end
  end
end
