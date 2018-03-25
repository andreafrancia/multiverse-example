class ShowTimerConfiguration
  def initialize read, clock
    @read = read
    @clock = clock
  end
  def configure sinatra_app
    read = @read
    clock = @clock
    sinatra_app.get '/' do
      require 'time'
      now = Time.parse(params['now'] || Time.now.to_s)
      earth = params['earth'] || 'production'
      require 'timer'
      timer = Timer.idrate(read.all_events(earth))
      require 'format_time'
      remaining_time = if timer.started?
                         format_time timer.remaining_time_at(now)
                       else
                         'not started'
                       end
      <<~HTML
      <span class='remaining_time'>#{remaining_time}</span>
      HTML
    end
  end
end

