class BuildIndicator < ActiveRecord::Base
  validates_presence_of :name
  
  def build_types_array
    project_build_type_pairs = (self.build_types || "").split(";")
    project_build_type_pairs.map do |full_location|
      els = full_location.split(":")
      {
        project_id: els[0],
        build_type_id: els[1]
      }
    end
  end
end
