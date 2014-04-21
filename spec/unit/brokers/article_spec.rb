require 'test_helper'
require 'brokers/article'

describe "Article Broker Interface" do
  before do
    @broker = RedHatSupportLib::Brokers::Article.new(nil)
  end
  it "has a method for searching articles" do
    @broker.must_respond_to(:search)
  end
  it "has a method for retrieving a single article" do
    @broker.must_respond_to(:get_article)
  end
end