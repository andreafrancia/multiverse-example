require 'conf/show_timer_configuration'

describe ShowTimerConfiguration do
  subject(:conf) { ShowTimerConfiguration.new read, clock }
  let(:clock) { double :clock }
  let(:read) { double :read }

  let(:user) do
    require 'sinatra'
    app = Sinatra.new
    conf.configure app
    Capybara::Session.new(:rack_test, app)
  end

  it do
    expect(read).to receive(:all_events).with('earth').and_return([
      [:start_new_timer, 25*60, Time.parse('9:00')],
    ])
    user.visit '/?now=9:00&earth=earth'

    remaining_time = user.find('.remaining_time').text

    expect(remaining_time).to eq('25:00')
  end

end
