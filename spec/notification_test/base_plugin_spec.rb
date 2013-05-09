require 'spec_helper'
require 'logger'
require 'tempfile'

require 'notification_test'

describe NotificationTest::NotificationPlugin do
  before(:each) do
    @plugin = NotificationTest::NotificationPlugin.new
    @plugin.logger = Logger.new(STDOUT)
    account_id = "a86ed6d4-c0bd-4a44-b49a-5ec29c3b314a"
    object_id = "9f73c8e9-188a-4603-a3ba-2ce684411fb9"
    event_type = "INVOICE_CREATION"
    object_type = "INVOICE"
    tenant_id = "b86fd6d4-c0bd-4a44-b49a-5ec29c3b3765"
    @kb_event = Killbill::Plugin::Event.new(event_type, object_type, object_id, account_id, tenant_id)
  end

  it "should start and stop correctly" do
    @plugin.start_plugin
    @plugin.stop_plugin
  end

  it "should should test charge" do
    output = @plugin.on_event(@kb_event)
  end

end
