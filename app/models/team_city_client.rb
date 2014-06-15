class TeamCityClient
  
  def initialize(httpClient)
    @httpClient = httpClient
  end
  
  def joint_build_status(build_types)
    responses = build_types.map { |build_type| @httpClient.last_build_status(build_type[:project_id], build_type[:build_type_id]) }
    statuses = responses.map { |response| response["build"][0]["status"]  }

    logger.debug "Statuses for build_types: #{build_types.to_s} #{statuses.to_s}"
    statuses.all? { |status| status == "SUCCESS" }
  end

  # Client creation helpers
  def self.new_with_config
    TeamCityClient.new(TeamCityHTTPClient.new_with_config)
  end
 
  def self.new_with_details(hostname, username, password)
    TeamCityClient.new(TeamCityHTTPClient.new(hostname, username, password))
  end
end

