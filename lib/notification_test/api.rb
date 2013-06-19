require 'date'

require 'killbill/notification'

=begin
class Killbill::Plugin::Model::ExtBusEvent
  def to_s
    "type = #{@event_type}, object_type = #{@object_type} : object_id = #{@object_id}, account_id = #{@account_id}, tenant_id = #{@tenant_id}"
  end
end
=end


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

      print "ENTER #{event.to_s}, class = #{event.class}"

      if event.event_type == :ACCOUNT_CREATION
        #
        # Retrieve account and update email
        #
        print "before get_account_by_id..."
        account = @kb_apis.account_user_api.get_account_by_id(event.object_id, @kb_apis.create_context)

        print "before update account..."
        updated_account = Killbill::Plugin::Model::Account.new
        updated_account.id=account.id
        updated_account.email="plugintest@plugin.com"
        @kb_apis.account_user_api.update_account(updated_account, @kb_apis.create_context)

        print "before tag definition creation..."
        @tag_definition = @kb_apis.tag_user_api.create_tag_definition("NotificationPlugin", "Tag for test NotificationTest", @kb_apis.create_context)

        print "before tag creation... #{@tag_definition.inspect}"
        @kb_apis.tag_user_api.add_tag(event.account_id, Killbill::Plugin::Model::ObjectType.new(:ACCOUNT), @tag_definition.id, @kb_apis.create_context)

      elsif event.event_type == :ACCOUNT_CHANGE

        #
        # Verify new email
        #
        print "before get_account_by_id..."
        account = @kb_apis.account_user_api.get_account_by_id(event.object_id, @kb_apis.create_context)
        validate(account.email, "plugintest@plugin.com")


      elsif event.event_type == :SUBSCRIPTION_CREATION
      elsif event.event_type == :INVOICE_CREATION
      elsif event.event_type == :SUBSCRIPTION_CANCEL
      elsif event.event_type == :PAYMENT_SUCCESS
      elsif event.event_type == :TAG_CREATION

        print "before getTagsForAccount.."
        tags = @kb_apis.tag_user_api.get_tags_for_account(event.account_id, @kb_apis.create_context)
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
