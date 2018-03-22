require 'capybara'

describe do
  let(:now) { double :now }

  it '/new' do
    allow(read).to receive(:all_events).and_return([])
    allow(clock).to receive(:now).and_return(now)
    expect(write).to receive(:append_events).with([
      [:start_new_timer, 25, now],
    ])

    user.visit '/new'
    user.fill_in 'duration', with: "25"
    user.click_on 'start'

    expect(user.current_path).to eq('/')
  end

  let(:user) do
    Capybara::Session.new(:rack_test, app)
  end

  it do
    expect(read).to receive(:all_events).and_return([
      [:start_new_timer, 25*60, Time.parse('9:00')],
    ])
    user.visit '/'

    remaining_time = user.find('.remaining_time').text

    expect(remaining_time).to eq('25:00')
  end
  let(:write) { double :write }
  let(:read) { double :read }
  let(:clock) { double :clock }
  def app
    require 'app'
    app = App.make(read, write, clock)
    app.class_eval do
      disable :show_exceptions
      enable :raise_errors
    end
    app
  end
end
