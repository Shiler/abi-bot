require 'nokogiri'
require 'open-uri'
require_relative 'console.rb'

class Rates

  # rates[0] - RUR, rates[1] - USD, rates[2] - EUR
  def Rates.get_rates
    rates = Array.new
    url = 'http://www.nbrb.by/Services/XmlExRates.aspx'
    response = Nokogiri::XML(open(url))
    rates << extract_by_id(response, 190)
    rates << extract_by_id(response, 145)
    rates << extract_by_id(response, 19)
    Console.rates_loaded
    rates
  end

  def Rates.extract_by_id(doc, id)
    {
        'char_code' => doc.xpath("//Currency[@Id=\"#{id}\"]//CharCode").to_s[/<CharCode>(.*)<\/CharCode>/, 1],
        'name' => doc.xpath("//Currency[@Id=\"#{id}\"]//Name").to_s[/<Name>(.*)<\/Name>/, 1],
        'rate' => doc.xpath("//Currency[@Id=\"#{id}\"]//Rate").to_s[/<Rate>(.*)<\/Rate>/, 1]
    }
  end

end