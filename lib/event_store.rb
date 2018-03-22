class EventStore
  def initialize store
    @store = store
  end
  def append_events events
    @store.transaction do
      @store[:events] ||= []
      @store[:events] += events
    end
  end
  def all_events
    events = @store.transaction do
      @store[:events] || []
    end
  end
end
