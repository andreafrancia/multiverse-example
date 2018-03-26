require 'app'
describe "App.in_production", :production do
  require 'support/app_shared_examples'
  it_behaves_like App
  require 'support/an_app_with_a_guestbook_shared_examples'
  #it_behaves_like AnAppWithAGuestbook

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
