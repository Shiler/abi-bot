require './lib/methods.rb'
require 'mechanize'
require 'nokogiri'

class Slogan

  def initialize(data, token)
    @token = token
    @id = data[:from_id]
    @question = data[:argument]
  end

  def get_slogan
    @question = @question.gsub("/slogan", '').strip
    if @question == '' || @question.nil?
      'Вы не ввели слово для слогана!'
    else
      parse_slogan(@question)
    end
  end

  def run
    Methods.send_message(@id, get_slogan, @token)
  end

  def parse_slogan(request)
    agent = Mechanize.new
    erfa = agent.get 'http://www.erfa.ru'
    search = erfa.form_with(:action => 'index.php')
    search.field_with(:name => 'slovoInput').value = request
    page = search.submit
    doc = Nokogiri::HTML(page.body, 'UTF-8')
    doc.xpath('//*[@class="generate"]').text
  end

end
