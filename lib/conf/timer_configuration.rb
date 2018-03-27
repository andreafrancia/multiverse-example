class TimerConfiguration
  def initialize read, write, clock
    @read = read
    @write = write
    @clock = clock
  end
  def configure sinatra_app
    write = @write
    read = @read
    clock = @clock
    sinatra_app.get '/timer' do
      now_as_string = params['now'] || clock.now.to_s
      require 'time'
      now = Time.parse(now_as_string)
      earth = params['earth'] || 'production'
      show_admin_inputs = params['a']

      require 'timer'
      timer = Timer.idrate(read.all_events(earth))
      remaining_time = timer.remaining_time_as_string(now)

      Page.new(remaining_time,now_as_string, show_admin_inputs, earth).to_html
    end
    sinatra_app.post '/timer' do
      duration = params['duration'].to_i * 60
      earth = params['earth'] || 'production'
      start_time = if params['start-time']
                     Time.parse(params['start-time'])
                   else
                     clock.now
                   end
      write.append_events(earth, [
        [:start_new_timer, duration, start_time],
      ])
      require 'url_with_earth'
      redirect UrlWithEarth.new('/timer', earth).to_url
    end
  end
  class Page
    def initialize remaining_time, now_as_string, show_admin_inputs, earth
      @remaining_time = remaining_time
      @now_as_string = now_as_string
      @show_admin_inputs = show_admin_inputs
      @earth = earth
    end
    def to_html
      require 'cgi/util'
      <<~HTML
      <span class='remaining_time'>#{@remaining_time}</span>
        <form method='POST' action='/timer?earth=#{CGI.escape_html @earth}'>
          <input type='text' name='duration'/>
          #{start_time_input}
          <input type='submit' value='start'/>
        </form>
      HTML
    end
    def start_time_input
      if @show_admin_inputs
        <<~HTML
          <input id='start-time' type='text' name='start-time' value='#{@now_as_string}'/>
        HTML
      else
        ''
      end
    end
  end
end
