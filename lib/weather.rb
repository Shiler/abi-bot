require 'rss'

class Weather

  def get_weather
    page = RSS::Parser.parse('http://www.pogoda.by/rss2/cityrss.php?q=26850')
    page.channel.item.description.gsub(' Информер погоды <a href=http://pogoda.by/meteoinformer/?city=26850>Минск</a>', '').gsub('&#176;' ,'°').split(' | ')
  end

end