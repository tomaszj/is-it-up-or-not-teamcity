require 'spec_helper'

describe TeamCityClient do

  before :each do
    @mockHttpClient = double("TeamCityHTTPlient")
    @client = TeamCityClient.new(@mockHttpClient)
  end

  context "when accessing build type" do
    it "should call TeamCityHTTPClient last_build_status" do
      expected_status = TeamCityBuildStatus.new(123, "SUCCESS")
      allow(@mockHttpClient).to receive(:last_build_status).once.and_return { expected_status } 

      build_status = @client.build_status_for_build_type({ project_id: "TestProject", build_type_id: "TestBuildType"})

      expect(build_status.status).to eq(expected_status.status)
    end
  end

  context "when accessing joint build type" do
    it "should call TeamCityHTTPClient respective number of times" do
      expected_status = TeamCityBuildStatus.new(123, "SUCCESS")
      allow(@mockHttpClient).to receive(:last_build_status).twice.and_return { expected_status } 
      build_statuses = @client.joint_build_status([
        { project_id: "TestProject", build_type_id: "TestBuildType"},
        { project_id: "TestProject2", build_type_id: "TestBuildType2"}
      ])

      expect(build_statuses).to be(true)
    end

    it "should return true if all builds are successful" do
      expected_status = TeamCityBuildStatus.new(123, "SUCCESS")
      allow(@mockHttpClient).to receive(:last_build_status).and_return { expected_status } 
      build_statuses = @client.joint_build_status([
        { project_id: "TestProject", build_type_id: "TestBuildType"},
        { project_id: "TestProject2", build_type_id: "TestBuildType2"}
      ])

      expect(build_statuses).to be(true)
    end

    it "should return false if any of builds is unsuccessful" do
      build_types = [
        { project_id: "TestProject", build_type_id: "TestBuildType"},
        { project_id: "TestProject2", build_type_id: "TestBuildType2"}
      ]
      success_status = TeamCityBuildStatus.new(123, "SUCCESS")
      failure_status = TeamCityBuildStatus.new(124, "FAILURE")

      allow(@mockHttpClient).to receive(:last_build_status).with("TestProject", "TestBuildType").and_return { success_status } 
      allow(@mockHttpClient).to receive(:last_build_status).with("TestProject2", "TestBuildType2").and_return { failure_status } 

      build_statuses = @client.joint_build_status(build_types)

      expect(build_statuses).to be(false)
    end
  end
end

