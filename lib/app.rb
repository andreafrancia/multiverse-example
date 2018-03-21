module App
  def self.production
    require 'puts_repo'
    make(PutsRepo.new(STDOUT), Time)
  end
  def self.make(repo, clock)
    require 'sinatra/base'
    Sinatra.new do
      enable :inline_templates
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
        repo.start_new_timer(duration, clock.now)
        redirect '/'
      end
    end
  end
end
