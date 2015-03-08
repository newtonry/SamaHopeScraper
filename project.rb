require "json"

class Project
  attr_accessor :doctor, :treatment, :stories
  
  def initialize(doctor, treatment, stories, location)
    @doctor = doctor
    @treatment = treatment
    @stories = stories
    @location = location
    @total_amount = nil
    @amount_needed = nil
  end
  
  def set_cost_and_amount_left_from_html(html)
    @amount_needed = turn_money_to_integers(html.css('div#secondary div.trench.text-center strong').text)
    @total_amount = turn_money_to_integers(html.css('div#secondary div.progress-messaging ul.bullets span.meta-text').first.text)
  end
  
  def turn_money_to_integers(text)
    text.split(" ").first.sub("$", "").to_i
  end
  
  def to_json
    {
      doctor_name: @doctor.name,
      doctor_image: @doctor.image,
      doctor_banner: @doctor.banner,
      doctor_quote: @doctor.quote,
      doctor_bio: @doctor.bio,
      treatment_name: @treatment.name,
      treatment_image: @treatment.image,
      treatment_description: @treatment.description,
      stories: @stories.map {|story| story.to_json},
      location: @location.name,
      amount_needed: @amount_needed,
      total_amount: @total_amount
    }.to_json
  end
end
