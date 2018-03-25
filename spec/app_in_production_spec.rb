require 'app'
describe "App.in_production" do
  require 'support/app_shared_examples'
  it_behaves_like App

  let(:user) do
    require 'capybara'
    require 'pry'
    require "selenium-webdriver"
    Capybara::Session.new(:selenium_chrome_headless, app)
  end
  let(:app) do
    require 'app'
    App.production
  end
end
