require 'nokogiri'
require 'rest-client'
require 'json'

require './keys.rb'

require './doctor.rb'
require './location.rb'
require './project.rb'
require './story.rb'
require './treatment.rb'

def create_event_with_name(name)
  projects = []

  SamaHopeClient.get_listed_doctors.each do |proj|
    response = ParseClient.create_project(proj)
    parse_project = JSON.parse(response)
  
    projects.push({
      "__type" => "Pointer",
      "className" => "Project",
      "objectId" => parse_project["objectId"]})
  end

  ParseClient.create_event_with_name_and_projects(name, projects)
end


class SamaHopeClient
  BASE_SAMAHOPE_URL = "http://www.samahope.org/"
  DOCTORS_LISTING_PAGE = "doctors/"
  
  def self.get_listed_doctors()
    url = BASE_SAMAHOPE_URL + DOCTORS_LISTING_PAGE
    page = Nokogiri::HTML(RestClient.get url)

    page.css("div#page div.doc-pic_wrap").map do |pic_wrap|
      slug_name = pic_wrap.css('a').first['href'].sub(BASE_SAMAHOPE_URL, "").sub("/", "")
      image = pic_wrap.css('img.attachment-post-thumbnail').first['src']  # I know it's a bit weird to grab it here, but this seems like the only place
    
      SamaHopeClient.project_from_name(slug_name, image)
    end
  end
  
  def self.project_from_name(slug_name, image=nil)
    doctor_url = BASE_SAMAHOPE_URL + slug_name
    page = Nokogiri::HTML(RestClient.get doctor_url)
    
    doctor = Doctor.from_html(page)
    doctor.image = image

    location = Location.from_html(page)

    treatment_html = page.css('div#primary div.entry-content .moat')[1]    
    treatment = Treatment.from_html(treatment_html)

    stories_html = page.css("div#primary div.patients-helped")
    stories = stories_html.css('.row section').map do |story_html|
      Story.from_html(story_html)
    end
  
    project = Project.new(doctor, treatment, stories, location)
    project.set_cost_and_amount_left_from_html(page)
    project
  end
end

class ParseClient
  PARSE_JS_URL = "https://#{PARSE_APP_ID}:javascript-key=#{PARSE_JS_KEY}@api.parse.com/1/classes/"

  def self.get_doctors()
    url = PARSE_JS_URL + "Doctor/"
    p RestClient.get url
  end

  def self.create_project(project)    
    url = PARSE_JS_URL + "Project/"
    RestClient.post url, project.to_json
  end

  def self.create_event_with_name_and_projects(name, projects)
    url = PARSE_JS_URL + "Event/"
    event_json = {
      name: name,
      projects: projects
    }.to_json
    RestClient.post url, event_json
  end
end

create_event_with_name("Ryan's Donation Extravaganza!")







