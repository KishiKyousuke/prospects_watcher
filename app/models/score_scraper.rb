require 'open-uri'
require 'nokogiri'

class ScoreScraper
  def initialize(url)
    @url = url
    @charset = nil
    @html = html
    @player_scores = []
  end

  def scrape
    page = Nokogiri::HTML.parse(@html, nil, @charset)
    table = page.css('#js-playerTable')
    table.search('tr').each do |node|
      data = []
      node.search('td').each do |n|
        data.push(n.at_css('a')[:href]) if n.at_css('a')
        data << n.text.gsub(/\n/, '').lstrip
      end
      @player_scores << data unless data.empty?
    end
    @player_scores
  end

  private

  def html
    @html = URI.open(@url) do |f|
      @charset = f.charset
      f.read
    end
  end
end
