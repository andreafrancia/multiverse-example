require 'capybara'

describe do

  it do
    user.visit '/'
    expect(user.text).to eq('not started')

    user.visit '/new?a=1'
    user.fill_in 'duration', with: 10
    user.fill_in 'start-time', with: '2018-03-25T16:00:00'
    user.click_on

    user.visit '/?now=2018-03-25T16:00:00'
    expect(user.find('.remaining_time').text).to eq('10:00')
    user.visit '/?now=2018-03-25T16:00:01'
    expect(user.find('.remaining_time').text).to eq('09:59')
  end

  let(:user) do
    require 'capybara'
    Capybara::Session.new(:rack_test, app)
  end

  def app
    require 'fake_pstore'
    backend = FakePstore.make
    require 'app'
    app = App.make(backend)
    app.class_eval do
      disable :show_exceptions
      enable :raise_errors
    end
    app
  end
end
