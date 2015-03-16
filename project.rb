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
    # @treatments_funded = nil
  end
  
  def set_cost_and_amount_left_from_html(html)
    @amount_needed = turn_money_to_integers(html.css('div#secondary div.trench.text-center strong').text)
    @total_amount = turn_money_to_integers(html.css('div#secondary div.progress-messaging ul.bullets span.meta-text').first.text)
    
    # @treatments_funded = turn_money_to_integers(html.css('div#secondary div.progress-messaging ul.bullets span.meta-text').first.text)
    # html.css('div#secondary div.sidebar-nav_item div.progress-messaging ul.bullets')[1]
    
  end
  
  
  
  
  
  
  
  def turn_money_to_integers(text)
    text.split(" ").first.sub("$", "").to_i
  end
  
  def to_json
    {
      doctorName: @doctor.name,
      doctorImage: @doctor.image,
      doctorBanner: @doctor.banner,
      doctorQuote: @doctor.quote,
      doctorBio: @doctor.bio,
      treatmentName: @treatment.name,
      treatmentImage: @treatment.image,
      treatmentDescription: @treatment.description,
      stories: @stories.map {|story| story.to_json},
      location: @location.name,
      amountNeeded: @amount_needed,
      totalAmount: @total_amount
    }.to_json
  end
end
