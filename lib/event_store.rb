class EventStore
  def initialize store
    @store = store
  end
  def append_events earth, events
    @store.transaction do
      @store[:events] ||= []
      @store[:events] += events.map do |event|
        [earth, event]
      end
    end
  end
  def all_events(earth)
    events = @store.transaction do
      @store[:events] || []
    end.select do |earth_event|
      event_earth, _ = earth_event
      event_earth == earth
    end.map do |earth_event|
      _, event = earth_event
      event
    end
  end
end
