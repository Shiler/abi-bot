require_relative 'rates.rb'
require_relative 'weather.rb'

class ExternalResources

  def ExternalResources.get
    {
        :rates => Rates.get_rates,
        :weather => Weather.get_weather
    }
  end

end