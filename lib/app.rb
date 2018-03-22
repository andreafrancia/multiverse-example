module App
  def self.production
    require 'yaml/store'
    backend = YAML::Store.new('events.yml')
    require 'event_store'
    make(nil, EventStore.new(backend), Time)
  end
  def self.make(read, write, clock)
    require 'sinatra/base'
    Sinatra.new do
      enable :inline_templates
      get '/' do
        now = params['now'] || Time.now
        require 'remaining_time'
        remaining_time = RemainingTime.idrate(read.all_events, now)
        require 'format_time'
        <<~HTML
        <span class='remaining_time'>#{format_time remaining_time}</span>
        HTML
      end
      get '/new' do
        <<~HTML
        <form method='POST' action='/new'>
          <input type='text' name='duration'/>
          <input type='submit' value='start'/>
        </form>
        HTML
      end
      post '/new' do
        duration = params['duration'].to_i
        write.append_events([
          [:start_new_timer, duration, clock.now],
        ])
        redirect '/'
      end
    end
  end
end
