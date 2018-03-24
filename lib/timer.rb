class Timer < Struct.new(:started?,
                         :start_time,
                         :duration)
  def remaining_time_at(time)
    end_time - time
  end
  def end_time
    start_time + duration
  end
  def self.idrate(events)
    started = false
    start_time = nil
    duration = nil
    events.each do |event|
      started = true
      start_time = event[2]
      duration = event[1]
    end
    return new(started, start_time, duration)
  end
end

