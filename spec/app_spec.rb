require 'app'

describe App do

  require 'shared_examples/an_app_with_a_timer'
  it_behaves_like AnAppWithATimer
  require 'shared_examples/an_app_with_a_guestbook'
  it_behaves_like AnAppWithAGuestbook

  let(:user) do
    require 'capybara'
    Capybara::Session.new(:rack_test, app)
  end

  def app
    require 'fake_pstore'
    backend = FakePstore.make
    require 'app'
    app = App.make(backend)
    app.disable :show_exceptions
    app.enable :raise_errors
    app
  end
end
