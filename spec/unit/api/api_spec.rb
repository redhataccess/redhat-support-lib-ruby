require 'test_helper'
require 'api/api'

describe "API interface" do
  before do
    @api = RedHatSupportLib::Api::API.new(RedHatSupportLib::Network::Config.new,
                                          {:max_http_size => 2048, :ftp_host => 'localhost'})
  end
  it "has a method for retrieving article broker" do
    @api.must_respond_to(:article_broker)
    @api.article_broker.must_be_instance_of(RedHatSupportLib::Brokers::Article)
  end
  it "has a method for retrieving attachements broker" do
    @api.must_respond_to(:attachment_broker)
    @api.attachment_broker.must_be_instance_of(RedHatSupportLib::Brokers::Attachment)
  end
  it "has a method for retrieving case broker" do
    @api.must_respond_to(:case_broker)
    @api.case_broker.must_be_instance_of(RedHatSupportLib::Brokers::Case)
  end
  it "has a method for retrieving problem broker" do
    @api.must_respond_to(:problem_broker)
    @api.problem_broker.must_be_instance_of(RedHatSupportLib::Brokers::Problem)
  end
  it "has a method for retrieving solution broker" do
    @api.must_respond_to(:solution_broker)
    @api.solution_broker.must_be_instance_of(RedHatSupportLib::Brokers::Solution)
  end
  it "has a method for retrieving sympton broker" do
    @api.must_respond_to(:symptom_broker)
    @api.symptom_broker.must_be_instance_of(RedHatSupportLib::Brokers::Symptom)
  end

  it "has a method for retrieving product broker" do
    @api.must_respond_to(:product_broker)
    @api.product_broker.must_be_instance_of(RedHatSupportLib::Brokers::Product)
  end
  it "has a method for retrieving group broker" do
    @api.must_respond_to(:group_broker)
    @api.group_broker.must_be_instance_of(RedHatSupportLib::Brokers::Group)
  end

  it "has a method for retrieving group broker" do
    @api.must_respond_to(:entitlement_broker)
    @api.entitlement_broker.must_be_instance_of(RedHatSupportLib::Brokers::Entitlement)
  end
  it "has a method for retrieving comment broker" do
    @api.must_respond_to(:comment_broker)
    @api.comment_broker.must_be_instance_of(RedHatSupportLib::Brokers::Comment)
  end

end
