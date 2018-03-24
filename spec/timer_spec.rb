require 'timer'

describe Timer do
  it do
    timer = Timer.idrate([])
    expect(timer.started?).to eq(false)
  end
  it do
    timer = Timer.idrate([
      [:start_new_timer, 25*60, Time.at(0)],
    ])

    expect(timer.started?).to eq(true)
    expect(timer.start_time).to eq(Time.at(0))
    expect(timer.duration).to eq(25*60)
    expect(timer.remaining_time_at(Time.at(0))).to eq(25*60)
    expect(timer.remaining_time_at(Time.at(25*60))).to eq(0*60)
  end
end

