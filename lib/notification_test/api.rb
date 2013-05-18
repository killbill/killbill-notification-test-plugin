require 'date'

require 'killbill/notification'

class Killbill::Plugin::Model::ExtBusEvent
  def to_s
    "type = #{@event_type}, object_type = #{@object_type} : object_id = #{@object_id}, account_id = #{@account_id}, tenant_id = #{@tenant_id}"
  end
end


module NotificationTest
  class NotificationPlugin < Killbill::Plugin::Notification


    def start_plugin
      super
    end

    def initialize(*args)
      super(*args)
      @tag_definition = nil
    end

    def on_event(event)
      
      print "ENTER #{event.to_s}"
      
      if event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CREATION)
        #
        # Retrieve account and update email
        #
        print "before get_account_by_id..."        
        account = @kb_apis.get_account_by_id(event.object_id)

        print "before update account..."
        updated_account = Killbill::Plugin::Model::Account.new(account.id, nil, nil, nil, nil, nil, nil, "plugintest@plugin.com", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
        @kb_apis.update_account(updated_account)
        
        print "before tag definition creation..."
        @tag_definition = @kb_apis.create_tag_definition("NotificationPlugin", "Tag for test NotificationTest")
        
        print "before tag creation... #{@tag_definition.inspect}"
        @kb_apis.add_tag(event.account_id, Killbill::Plugin::Model::ObjectType.new(:ACCOUNT), @tag_definition.id)

      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CHANGE)
        
        #
        # Verify new email 
        #
        print "before get_account_by_id..."        
        account = @kb_apis.get_account_by_id(event.object_id)
        validate(account.email, "plugintest@plugin.com")
        
        
      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:SUBSCRIPTION_CREATION)
      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:INVOICE_CREATION)
      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:SUBSCRIPTION_CANCEL)
      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:PAYMENT_SUCCESS)
      elsif event.event_type == Killbill::Plugin::Model::ExtBusEventType.new(:TAG_CREATION)

        print "before getTagsForAccount.."
        tags = @kb_apis.get_tags_for_account(event.account_id)
        validate(tags.size, 1)
        validate(tags.get(0).tag_definition_id, @tag_definition)
      end
      
      print "EXIT #{event.to_s}"

    end
    
    def validate(value, expected)
      print "VALIDATION Got #{value} : expected #{expected}"      
    end
    
    def print(msg)
      puts "*******************************************       NotificationTestPlugin #{msg}"
      $stdout.flush 
    end
  end
end
