class PutsRepo
  def initialize stdout
    @stdout = stdout
  end

  def start_new_timer duration, start_time
    @stdout.puts "Started timer of #{duration} at #{start_time}"
  end

end

