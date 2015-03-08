require "json"

class Treatment
    attr_accessor :name, :image, :description
    
    def initialize(name, image, description)
      @name = name
      @image = image   
      @description = description
    end
    
    def self.from_html(html)
      name = html.css('div.treatment_description h3').text
      image = html.css('img.badge').first['src']
      description = html.css('div.treatment_description p').map do |paragraph|
        paragraph.text
      end.join("\n")
      Treatment.new(name, image, description)
    end
    
    def to_json()
        {
          :name => @name,
          :image => @image,
          :description => @description
      }.to_json
    end
end
