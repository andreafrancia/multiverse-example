class StartTimerConfiguration
  def initialize write, clock
    @write = write
    @clock = clock
  end
  def configure sinatra_app
    write = @write
    clock = @clock
    sinatra_app.get '/new' do
      <<~HTML
        <form method='POST' action='/new'>
          <input type='text' name='duration'/>
          <input type='submit' value='start'/>
        </form>
      HTML
    end
    sinatra_app.post '/new' do
      duration = params['duration'].to_i
      write.append_events([
        [:start_new_timer, duration, clock.now],
      ])
      redirect '/'
    end
  end
end
