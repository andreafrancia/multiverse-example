require 'format_time'

describe 'format_time' do
  it { expect(format_time 0).to eq('00:00') }
  it { expect(format_time 1).to eq('00:01') }
  it { expect(format_time 10).to eq('00:10') }
  it { expect(format_time 4*60 + 10 ).to eq('04:10') }
  it { expect(format_time -1 ).to eq('Rang!') }
end
