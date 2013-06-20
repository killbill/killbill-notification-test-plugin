require 'spec_helper'
require 'logger'
require 'tempfile'

require 'notification_test'

class FakeJavaUserAccountApi
  # Returns an account where we specify the currency for the report group
  def get_account_by_id(id, context)
    account = Killbill::Plugin::Model::Account.new
    account.id=id
    account
  end

  def update_account(updated_account, context)
  end
end

class FakeTagUserApi
  def add_tag(account_id, object_type, tag_definition_id, context)
  end

  def create_tag_definition(type, desc, context)
  end

  def get_tags_for_account(account_id, context)
  end

end


describe NotificationTest::NotificationPlugin do
  before(:each) do

    svcs = {:account_user_api =>  FakeJavaUserAccountApi.new,
            :tag_user_api => FakeTagUserApi.new }
    
    kb_apis = Killbill::Plugin::KillbillApi.new("foo", svcs)

    @plugin = NotificationTest::NotificationPlugin.new
    @plugin.logger = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

    account_id = "a86ed6d4-c0bd-4a44-b49a-5ec29c3b314a"
    object_id = "9f73c8e9-188a-4603-a3ba-2ce684411fb9"
    event_type = "INVOICE_CREATION"
    object_type = "INVOICE"
    tenant_id = "b86fd6d4-c0bd-4a44-b49a-5ec29c3b3765"
    @kb_event = Killbill::Plugin::Model::ExtBusEvent.new
    @kb_event.event_type=event_type
    @kb_event.object_type=object_type
    @kb_event.account_id=account_id
    @kb_event.tenant_id=tenant_id
  end

  it "should start and stop correctly" do
    @plugin.start_plugin
    @plugin.stop_plugin
  end

  it "should should test charge" do
    output = @plugin.on_event(@kb_event)
  end

end
