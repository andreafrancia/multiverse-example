module App
  def self.production
    require 'yaml/store'
    backend = YAML::Store.new('events.yml')
    require 'event_store'
    event_store = EventStore.new(backend)
    make(event_store, event_store, Time)
  end
  def self.make(read, write, clock)
    configurations = []
    require 'conf/show_timer_configuration'
    configurations << ShowTimerConfiguration.new(read, clock)
    require 'conf/start_timer_configuration'
    configurations << StartTimerConfiguration.new(write, clock)
    require 'sinatra/base'
    app = Sinatra.new
    configurations.each do |conf|
      conf.configure app
    end
    app
  end
end
