class Api::V1::BuildIndicatorsController < ApplicationController
  def index
    @build_indicators = BuildIndicator.all
    render json: @build_indicators
  end
  
  def status
    @build_indicator = BuildIndicator.find(params[:id])
    status = TeamCityClient.new_with_config.joint_build_status(@build_indicator.build_types_array)
    render json: status
  end
end
