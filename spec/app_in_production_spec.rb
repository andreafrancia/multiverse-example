require 'app'

describe App, :production do

  require 'shared_examples/an_app_with_a_timer_simple'
  #it_behaves_like AnAppWithATimerSimple

  require 'shared_examples/an_app_with_a_timer'
  it_behaves_like AnAppWithATimer

  require 'shared_examples/an_app_with_a_guestbook'
  it_behaves_like AnAppWithAGuestbook

  let(:user) do
    require 'capybara'
    require "selenium-webdriver"
    Capybara.app_host = 'https://limitless-headland-65698.herokuapp.com/'
    Capybara::Session.new(:selenium_chrome_headless)
  end
  let(:app) do
    require 'app'
    App.production
  end
end
