module App
  def self.production
    require 'yaml/store'
    backend = YAML::Store.new('events.yml')
    make(backend)
  end
  def self.make(backend)
    clock = Time
    require 'event_store'
    event_store = EventStore.new(backend)
    read = event_store
    write = event_store
    configurations = []
    require 'conf/show_timer_configuration'
    configurations << ShowTimerConfiguration.new(read, clock)
    require 'conf/start_timer_configuration'
    configurations << StartTimerConfiguration.new(write, clock)
    require 'conf/guestbook_configuration'
    configurations << GuestbookConfiguration.new("/guestbook", read, write)
    require 'sinatra/base'
    app = Sinatra.new
    configurations.each do |conf|
      conf.configure app
    end
    app
  end
end
