require 'conf/guestbook_configuration'

describe GuestbookConfiguration do
  subject(:conf) {GuestbookConfiguration.new "/my/guestbook", read, write}
  let(:read) {double :read, all_events: []}
  let(:write) {double :write}

  let(:app) do
    require 'sinatra'
    app = Sinatra.new
    app.disable :show_exceptions
    app.enable :raise_errors
    conf.configure app
    app
  end

  let(:user) do
    Capybara::Session.new(:rack_test, app)
  end

  it 'displays signatures' do
    require 'support/read_signatures'
    user.extend ReadSignatures
    expect(read).to receive(:all_events).with('earth').and_return([
                                                                      [:guestbook_signed, "Bruce", "Banner"],
                                                                      [:guestbook_signed, "Tony", "Stark"],
                                                                  ])
    user.visit '/my/guestbook?earth=earth'

    expect(user.signatures_read).to eq(["Bruce Banner", "Tony Stark"])
  end

  describe 'the form' do
    let(:earth_fields) { user.all('#earth', visible: false).to_a }
    context 'when earth is specified' do
      subject(:earth_field) {earth_fields.first}
      before {user.visit '/my/guestbook?earth=earth-616'}
      it {expect(earth_field[:type]).to eq('hidden')}
      it {expect(earth_field[:name]).to eq('earth')}
      it {expect(earth_field[:value]).to eq('earth-616')}
    end
    context 'when earth is specified' do
      it {expect(earth_fields).to eq([])}
    end
  end

  it 'records a signature' do
    require 'rack/test'
    browser = Rack::Test::Session.new(app)
    expect(write).to receive(:append_events).with('earth-1',
                                                  [
                                                      [:guestbook_signed, "Tony", "Stark"]
                                                  ]
    )
    browser.post '/my/guestbook',
                 'first-name' => "Tony",
                 'last-name' => "Stark",
                 'earth' => 'earth-1'

    expect(redirect_of(browser.last_response)).to eq([302, "/my/guestbook?earth=earth-1"])
  end

  it 'does not redirects ' do
    require 'rack/test'
    browser = Rack::Test::Session.new(app)
    allow(write).to receive(:append_events)

    browser.post '/my/guestbook',
                 'first-name' => "Tony",
                 'last-name' => "Stark"

    expect(redirect_of(browser.last_response)).to eq([302, "/my/guestbook"])
  end


  def redirect_of response
    [response.status, path(response.location)]
  end

  def path location
    require 'uri'
    uri = URI.parse(location)
    if uri.query
      "#{uri.path}?#{uri.query}"
    else
      "#{uri.path}"
    end
  end

end
