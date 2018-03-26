require 'app'

describe App do

  require 'support/app_shared_examples'
  it_behaves_like App
  require 'support/an_app_with_a_guestbook_shared_examples'
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
