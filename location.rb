class Location
  attr_accessor :coordinates, :name

  def initialize(name, coordinates)
    @name = name
    @coordinates = coordinates
  end
  
  def self.from_html(html)
    name = html.css("header.entry-header strong").first.text
    html.css("header.entry-header a").first['href'] # seems like a pain to parse these now since some are bitly links and some aren't    
    Location.new(name, nil)
  end
end