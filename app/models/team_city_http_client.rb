class TeamCityHTTPClient
  include HTTParty
  
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
    full_response = self.class.get("/projects/id:#{project_id}/buildTypes/id:#{build_type_id}/builds/?locator=lookupLimit:1", self.request_headers)
    response = full_response["build"][0]
    TeamCityBuildStatus.new(response["id"], response["status"])
  end
  
  def request_headers
    { basic_auth: @auth, headers: { "Accept" => 'application/json' } }
  end

  def self.new_with_config
    TeamCityHTTPClient.new(
      Rails.application.secrets.team_city["hostname"],
      Rails.application.secrets.team_city["username"],
      Rails.application.secrets.team_city["password"]
      )
  end
end
