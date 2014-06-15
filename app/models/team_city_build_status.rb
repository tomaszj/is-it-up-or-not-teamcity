class TeamCityBuildStatus
  attr_accessor :build_id, :status

  def initialize(build_id, status)
    @build_id = build_id
    @status = status
  end

  def to_s
    "Build status: #{@status}"
  end
end
