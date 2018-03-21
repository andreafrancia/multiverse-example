require 'capybara'

describe do
  let(:now) { double :now }

  it do
    user = Capybara::Session.new(:rack_test, app)
    allow(clock).to receive(:now).and_return(now)
    expect(repo).to receive(:start_new_timer).with(25, now)

    user.visit '/new'
    user.fill_in 'duration', with: "25"
    user.click_on 'start'

    expect(user.current_path).to eq('/')
  end

  let(:user) do
    require 'rack/test'
    Rack::Test::Session.new(app)
  end

  it do
    allow(clock).to receive(:now).and_return(now)
    expect(repo).to receive(:start_new_timer).with(25, now)

    user.post '/new', duration: "25"

    expect(user.last_response.status).to eq(302)
    expect(user.last_response.location).to eq('http://example.org/')
  end
  let(:repo) { double :repo }
  let(:clock) { double :clock }
  def app
    require 'app'
    app = App.make(repo, clock)
    app.class_eval do
      disable :show_exceptions
      enable :raise_errors
    end
    app
  end
end
