require_relative '../brokers/broker'
require_relative '../brokers/article'
require_relative '../brokers/case'
require_relative '../brokers/solution'
require_relative '../brokers/symptom'
require_relative '../brokers/problem'
require_relative '../brokers/attachment'
require_relative '../brokers/product'
require_relative '../brokers/entitlement'
require_relative '../brokers/comment'
require_relative '../brokers/group'

require_relative '../network/http_connection'

module RedHatSupportLib
  module Api
    class API
      attr_reader :article_broker, :case_broker, :solution_broker
      attr_reader :symptom_broker, :problem_broker, :attachment_broker
      attr_reader :product_broker, :group_broker, :entitlement_broker, :comment_broker

      def initialize(network_config, attachments_config)
        @connection = Network::HttpConnection.new(network_config)
        @article_broker = Brokers::Article.new(@connection)
        @case_broker = Brokers::Case.new(@connection)
        @solution_broker = Brokers::Solution.new(@connection)
        @symptom_broker = Brokers::Symptom.new(@connection)
        @problem_broker = Brokers::Problem.new(@connection)
        @comment_broker = Brokers::Comment.new(@connection)
        @attachment_broker = Brokers::Attachment.new(@connection, @comment_broker, attachments_config)
        @product_broker = Brokers::Product.new(@connection)
        @group_broker = Brokers::Group.new(@connection)
        @entitlement_broker = Brokers::Entitlement.new(@connection)

      end

      def self.log_location(path)

      end
    end

  end
end
