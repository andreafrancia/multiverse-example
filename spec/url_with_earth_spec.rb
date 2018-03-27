require 'conf/timer_configuration'
require 'url_with_earth'

describe UrlWithEarth do
  it do
    expect(UrlWithEarth.new('/path', 'production').to_url).
        to eq("/path")
    expect(UrlWithEarth.new('/path', 'earth').to_url).
        to eq("/path?earth=earth")
  end
end
