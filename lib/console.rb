require 'colorize'
require 'slop'

class Console

  def get_parameters
    opts = Slop.parse do |o|
      o.string '...'
    end
    opts
  end

  def get_token
    url = get_parameters.arguments[0]
    arr = url.scan(/#access_token=(.*)&expires_in=/).flatten
    if (!arr.any?)
      bad_url
    end
    arr.first
  end

  # ---- notifications block ----

  def bad_url
    puts 'Url is not valid! Please, check it and run script again.'.colorize(:red)
    exit
  end

end
