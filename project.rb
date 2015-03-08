require "json"

class Project
  attr_accessor :doctor, :treatment, :stories
  
  def initialize(doctor, treatment, stories)
    @doctor = doctor
    @treatment = treatment
    @stories = stories    
  end
  
  def to_json()      
    {
      doctor: @doctor.to_json,
      treatment: @treatment.to_json,
      stories: @stories.map {|story| story.to_json}
    }.to_json
  end  
end
