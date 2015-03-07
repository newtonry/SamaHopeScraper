require 'nokogiri'
require 'rest-client'

require './doctor.rb'
require './treatment.rb'
require './story.rb'



class SamaHopeClient
  BASE_SAMAHOPE_URL = "http://www.samahope.org/"
  DOCTORS_LISTING_PAGE = "doctors/"
  
  def self.get_listed_doctors()
    url = BASE_SAMAHOPE_URL + DOCTORS_LISTING_PAGE
    page = Nokogiri::HTML(RestClient.get url)

    links = page.css("h1.entry-title a").map do |link|
      p link['href'].sub(BASE_SAMAHOPE_URL, "").sub("/", "")
    end
    
    links.each do |link|
      SamaHopeClient.doctor_by_name(link)
    end
  end
  
  def self.doctor_by_name(name)
    doctor_url = BASE_SAMAHOPE_URL + name

    page = Nokogiri::HTML(RestClient.get doctor_url)
    self.doctor_from_page(page)
  end
  
  def self.doctor_from_page(page)
    doctor = Doctor.new

    # Header
    doctor.banner_url = page.css('header#masthead .masthead_img-wrap img')[0]['src']
    doctor.quote_block = page.css('header#masthead .quote-block .text').first.text
    
    # Main content
    name = page.css('div#primary header.entry-header h1').first.text
    # missing location
    bio = page.css('div#primary div.entry-content .moat')[0]
    
    bio_chunked = bio.css('p').map do |paragraph|
      paragraph.text
    end
    
    # Treatment
    treatment_html = page.css('div#primary div.entry-content .moat')[1]    
    treatment = Treatment.from_html(treatment_html)

    # Patients Helped
    stories_html = page.css("div#primary div.patients-helped")
    stories = stories_html.css('.row section').map do |story_html|
      Story.from_html(story_html)
    end
  end
end

SamaHopeClient.get_listed_doctors