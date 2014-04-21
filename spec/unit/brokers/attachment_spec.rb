require 'test_helper'
require 'brokers/attachment'

describe "Attachment Broker Interface" do
  before do
    @broker = RedHatSupportLib::Brokers::Attachment.new(nil,nil,nil)
  end
  it "has a method for searching " do
    @broker.must_respond_to(:list)
  end
  it "has a method for retrieving a single attachment" do
    @broker.must_respond_to(:get)
  end
  it "has a method for retrieving a single attachment" do
    @broker.must_respond_to(:delete)
  end
  it "has a method for retrieving a single attachment" do
    @broker.must_respond_to(:add)
  end
end
