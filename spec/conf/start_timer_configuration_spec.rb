require 'conf/start_timer_configuration'

describe StartTimerConfiguration do
  subject(:conf) { StartTimerConfiguration.new write, clock }
  let(:clock) { double :clock, now:now }
  let(:write) { double :write }
  let(:now) { double :now }

  let(:user) do
    require 'sinatra'
    app = Sinatra.new
    conf.configure app
#    app.disable :show_exceptions
#    app.enable :raise_errors
    require 'capybara'
    Capybara::Session.new(:rack_test, app)
  end


  it 'without a=1' do
    expect(write).to receive(:append_events).with('production', [
      [:start_new_timer, 25 * 60 , now],
    ])

    user.visit '/new'
    user.fill_in 'duration', with: "25"
    user.click_on 'start'

    expect(user.current_path).to eq('/')
  end

  it '/new' do
    require 'time'
    inserted_time = Time.parse("2018-02-01T09:00")
    expect(write).to receive(:append_events).with('production', [
      [:start_new_timer, 25 * 60, inserted_time],
    ])

    user.visit '/new?a='
    user.fill_in 'duration', with: "25"
    user.fill_in 'start-time', with: "2018-02-01T09:00"
    user.click_on 'start'

    expect(user.current_path).to eq('/')
  end

  describe 'shows start_time only when called with ?a=1' do
    before do
      now = Time.parse('1970-01-01 01:00:00 +0000')
      allow(clock).to receive(:now).and_return(now)
    end
    it do
      user.visit '/new?a=1'
      expect(start_time_values).to eq(['1970-01-01 01:00:00 +0000'])
    end
    it do
      user.visit '/new'
      expect(start_time_values).to eq([])
    end
    def start_time_values
      user.all('#start-time').map do |field|
        field[:value]
      end
    end
  end

end
