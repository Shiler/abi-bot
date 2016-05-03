require 'nokogiri'
require 'open-uri'

class Parser

  def Parser.get_groups
    gr = Hash.new
    url = 'http://www.bsuir.by/schedule/rest/studentGroup'
    @doc = Nokogiri::XML(open(url))
    groups = @doc.xpath('//studentGroup').to_a
    groups.each_index do |index|
      key = @doc.xpath("//studentGroup[#{index}]//name").text
      if key != '' and !key.nil?
        value = {
            :id => @doc.xpath("//studentGroup[#{index}]//id").text,
            :course =>@doc.xpath("//studentGroup[#{index}]//course").text
        }
        gr[key] = value
      end
    end
    gr
  end

  def Parser.update_groups
    groups = get_groups
    data = Marshal.dump(groups)
    open('bsuir_schedule/groups.txt', 'wb') { |f| f.puts data }
  end

  def Parser.groups_from_file
    data = File.read('bsuir_schedule/groups.txt')
    Marshal.load(data)
  end

  def Parser.get_schedule(group)
    id = get_groups[group.to_s][:id]
    puts id
  end

end

hash = Parser.groups_from_file
