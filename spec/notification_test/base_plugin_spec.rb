require 'spec_helper'
require 'logger'

require 'notification_test'

describe NotificationTest::NotificationPlugin do

  before(:each) do
    kb_apis = Killbill::Plugin::KillbillApi.new("killbill-notification-test", {})

    @plugin         = NotificationTest::NotificationPlugin.new
    @plugin.logger  = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

    @kb_event             = Killbill::Plugin::Model::ExtBusEvent.new
    @kb_event.event_type  = :INVOICE_CREATION
    @kb_event.object_type = :INVOICE
    @kb_event.object_id   = "9f73c8e9-188a-4603-a3ba-2ce684411fb9"
    @kb_event.account_id  = "a86ed6d4-c0bd-4a44-b49a-5ec29c3b314a"
    @kb_event.tenant_id   = "b86fd6d4-c0bd-4a44-b49a-5ec29c3b3765"
  end

  it "should start and stop correctly" do
    @plugin.start_plugin
    @plugin.stop_plugin
  end

  it "should should test receiving an event" do
    file_name = '/var/tmp/killbill-notification-test.txt'

    output = @plugin.on_event(@kb_event)
    output.should be_nil

    File.file?(file_name).should be_true
    File.delete file_name
  end
end
