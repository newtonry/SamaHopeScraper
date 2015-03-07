class Doctor
  attr_accessor :name, :image, :banner, :quote, :bio

  def initialize(name, image, banner, quote, bio)
    @name = name
    @image = nil
    @banner = banner
    @quote = quote
    @bio = bio
  end

  def self.from_html(html)
    banner = html.css('header#masthead .masthead_img-wrap img')[0]['src']
    quote = html.css('header#masthead .quote-block .text').first.text
    name = html.css('div#primary header.entry-header h1').first.text
    # missing location
    bio_moat = html.css('div#primary div.entry-content .moat')[0]
    
    bio = bio_moat.css('p').map do |paragraph|
      paragraph.text
    end
    
    Doctor.new(name, nil, banner, quote, bio)
  end
end
