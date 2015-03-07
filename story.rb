class Story
  attr_accessor :patients, :image, :story_content
  
  def initialize(patients, image, story_content)
    @patients = patients
    @image = image
    @story_content = story_content
  end  
  
  def self.from_html(html)
    patients = html.css('h3').text
    image = html.css('.patient-pic_wrap img').first['src']
    story_content = html.css('p').map do |paragraph|
      paragraph.text
    end
    
    Story.new(patients, image, story_content)    
  end
end
