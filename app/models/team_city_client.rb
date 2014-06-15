class TeamCityClient
  
  def initialize(httpClient)
    @httpClient = httpClient
  end

  def build_status_for_build_type(build_type)
    @httpClient.last_build_status(build_type[:project_id], build_type[:build_type_id])
  end

  def joint_build_status(build_types)
    build_statuses = build_types.map { |build_type| self.build_status_for_build_type(build_type) }

    Rails.logger.debug "Statuses for build_types: #{build_types.to_s} #{build_statuses.to_s}"
    build_statuses.all? { |build_status| build_status.status == "SUCCESS" }
  end

  # Client creation helpers
  def self.new_with_config
    TeamCityClient.new(TeamCityHTTPClient.new_with_config)
  end
 
  def self.new_with_details(hostname, username, password)
    TeamCityClient.new(TeamCityHTTPClient.new(hostname, username, password))
  end
end

