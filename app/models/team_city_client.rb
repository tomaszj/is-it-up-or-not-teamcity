class TeamCityClient
  
  def initialize(httpClient)
    @httpClient = httpClient
  end
  
  def self.new_with_config
    TeamCityClient.new(TeamCityHTTPClient.new_with_config)
  end
  
  def self.new_with_details(hostname, username, password)
    TeamCityClient.new(TeamCityHTTPClient.new(hostname, username, password))
  end
  
  def joint_build_status(build_types)
    # puts "Build types: #{build_types.to_s}"
    responses = build_types.map { |build_type| @httpClient.last_build_status(build_type[:project_id], build_type[:build_type_id]) }
    # puts "Responses: #{responses.to_s}"
    statuses = responses.map { |response| response["build"][0]["status"]  }
    puts "Statuses: #{statuses.to_s}"
    statuses.all? { |status| status == "SUCCESS" }
  end
end

class TeamCityHTTPClient
  include HTTParty
  
  def self.new_with_config
    TeamCityHTTPClient.new(
      Rails.application.secrets.team_city["hostname"],
      Rails.application.secrets.team_city["username"],
      Rails.application.secrets.team_city["password"]
      )
  end
  
  def initialize(hostname, username, password)
    self.class.base_uri hostname + "/httpAuth/app/rest"
    @auth = {
      username: username,
      password: password
    }
  end
  
  def build_types_for_project(project_id)
    self.class.get("/projects/id:#{project_id}/buildTypes", self.request_headers)
  end
  
  def last_build_status(project_id, build_type_id)
    self.class.get("/projects/id:#{project_id}/buildTypes/id:#{build_type_id}/builds/?locator=lookupLimit:1", self.request_headers)
  end
  
  def request_headers
    { basic_auth: @auth, headers: { "Accept" => 'application/json' } }
  end
end