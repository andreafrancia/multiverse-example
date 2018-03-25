class StartTimerConfiguration
  def initialize write, clock
    @write = write
    @clock = clock
  end
  def configure sinatra_app
    write = @write
    clock = @clock
    sinatra_app.get '/new' do
      earth = params['earth'] || 'production'
      start_time_input = if params['a']
                           <<~HTML
          <input id='start-time' type='text' name='start-time' value='#{clock.now.to_s}'/>
                           HTML
                         else
                           ''
                         end
      require 'cgi/util'
      <<~HTML
        <form method='POST' action='/new?earth=#{CGI.escape_html earth}'>
          <input type='text' name='duration'/>
          #{start_time_input}
          <input type='submit' value='start'/>
        </form>
      HTML
    end
    sinatra_app.post '/new' do
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
      redirect '/'
    end
  end
end
