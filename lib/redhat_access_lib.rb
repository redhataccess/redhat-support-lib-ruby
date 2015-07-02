require 'pp'
require 'yaml'
require_relative  'api/api'
require_relative  'api/telemetry_api'


# auth_config = YAML::load(File.read(File.join(ENV['HOME'], 'portal-auth.yml')))
# config = RedHatSupportLib::Network::Config.new
# config.base_uri = 'https://api.access.redhat.com'
# config.username=auth_config['username']
# config.password = auth_config['password']
# config.proxy= 'http://user1:password@localhost:3128/'


# config.log_location = '/tmp/support_lib_log.txt'
# attachments_config = {:max_http_size => 2048, :ftp_host => '192.168.122.1',:ftp_remote_dir =>"/incoming"}
# access = RedHatSupportLib::Api::API.new(config,attachments_config)


# solutions = access.solution_broker.search('JBOSS+SAM', 50);
# pp solutions
# # #Solutions tests
# # if solutions
# #   solutions.each do |solution|
# #     pp access.solution_broker.get_solution(solution['id'])
# #   end
# # end

# # #Articles tests
# # articles = access.article_broker.search('JBOSS', 50);
# # pp articles
# # if articles
# #   articles.each do |article|
# #     pp access.article_broker.get_article(article['id'])
# #   end
# # end

# # #Problems
# # problems = access.problem_broker.diagnose_string("JBOSS NullPointerException")
# # pp problems
# # if problems
# #   problems.each do |prob|
# #     pp access.solution_broker.get_solution(prob[:solution_id])
# #   end
# # end
# # file_probs = access.problem_broker.diagnose_file('/opt/jbdevstudio/runtimes/jboss-eap/standalone/log/boot.log')
# # pp file_probs
# # if file_probs
# #   file_probs.each do |prob|
# #     pp access.solution_broker.get_solution(prob[:solution_id])
# #   end
# # end

# #---------------Cases--------------------------
# #mycase  = access.case_broker.get("01017414")
# #pp mycase
# #filter = RedHatSupportLib::Brokers::CaseFilter.new
# #keywords=[], include_closed=false, detail, group, start_date, end_date,
# #              count, start, kwargs)
# #mycases = access.case_broker.list([],true,true,nil,nil,nil,10,0,nil)
# #pp mycases

# #created_case = access.case_broker.create("Subscription Asset Manager", 1.1, "Group test",
# #                                        "Test Case created via Ruby, Group test","4 (Low)", '817')
# #pp created_case
# #if created_case
# #  pp access.case_broker.get(created_case)
# #end
# #pp access.case_broker.list_severities
# #pp access.case_broker.list_case_types


# #updated = access.case_broker.update("01010070", "Red Hat HPC","5.4", nil,"Waiting on Customer","3 (Normal)")
# #updated = access.case_broker.update("01010070", nil, nil,"Bug requiest 7","Waiting on Customer",nil, "Bug")
# #pp updated

# #-----------------Symptoms------------------------
# #file_symptoms = access.symptom_broker.diagnose_file('/opt/jbdevstudio/runtimes/jboss-eap/standalone/log/server.log.2013-12-19')
# #pp file_symptoms
# #

# #------------------Products-----------------------
# #pp access.product_broker.list


# #-------------------Groups-------------------------
# #pp access.group_broker.list

# #-------------------Entitlements-------------------------
# #pp access.entitlement_broker.list

# #-------------------Comments--------------------------
# #pp access.comment_broker.get("01010070", "a0aK0000003qnajIAA")
# #pp access.comment_broker.add("01010070", "Added via ruby client, AGAIN", false, false)
# #pp access.comment_broker.add("Comment added by ruby api 3",
# #                              "01010069",
# #                              false,
# #                              false)
# #pp access.comment_broker.list("01010069",nil,nil)

# #------------------Attachments-------------------------
# #pp access.attachment_broker.list("01015184","2014-01-24","2014-01-24")
# attachment_list = access.attachment_broker.list("01465941",nil,nil,nil)
# pp attachment_list
# attachments = access.attachment_broker.add("01465941",
#                                            false,
#                                             "/tmp/dummy.txt",
#                                             "description2")
# pp attachments
# attachment_list = access.attachment_broker.list("01465941",nil,nil,nil)
# pp attachment_list
