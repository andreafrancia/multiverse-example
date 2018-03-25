require 'app'

describe App do

  require 'support/app_shared_examples'
  it_behaves_like App

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
