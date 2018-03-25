require 'event_store'

describe EventStore do
  subject(:store) { EventStore.new(backend) }

  let(:backend) do
    require 'fake_pstore'
    FakePstore.make
  end

  before do
    require 'fileutils'
    FileUtils.rm_f 'tmp/events.yml'
    FileUtils.mkdir_p 'tmp'
  end

  it 'starts empty' do
    events = store.all_events('earth')

    expect(events).to eq([])
  end

  it 'append an event' do
    store.append_events('earth', [{ event_id: "event_id" }])

    events = store.all_events('earth')
    expect(events).to eq([{ event_id: "event_id" }])
  end
  it 'two events' do
    store.append_events('earth', [ { event_id: "event_1" },
                                   { event_id: "event_2" }])

    events = store.all_events('earth')
    expect(events).to eq([
      { event_id: "event_1" },
      { event_id: "event_2" },
    ])
  end
  it 'different earths' do
    store.append_events('earth1', [{ event_id: "event_id1" }])
    store.append_events('earth2', [{ event_id: "event_id2" }])

    events = store.all_events('earth1')
    expect(events).to eq([{ event_id: "event_id1" }])
  end
end
