require 'conf/timer_configuration'

describe TimerConfiguration do
  subject(:conf) {TimerConfiguration.new read, write, clock}
  let(:clock) {double :clock, now: now}
  let(:read) {double :read}
  let(:write) {double :write}
  let(:now) {double :now, to_s: Time.at(0).to_s}

  let(:user) do
    require 'sinatra'
    app = Sinatra.new
    conf.configure app
    app.disable :show_exceptions
    app.enable :raise_errors
    require 'capybara'
    Capybara::Session.new(:rack_test, app)
  end

  describe 'remaining time text' do
    it 'when none started' do
      allow(read).to receive(:all_events).with('earth').and_return([])

      user.visit '/timer?earth=earth'

      expect(remaining_time_read).to eq('not started')
    end

    it 'when started' do
      allow(read).to receive(:all_events).with('earth').and_return(
          [
              [:start_new_timer, 25 * 60, Time.parse('9:00')],
          ])

      user.visit '/timer?now=9:00&earth=earth'

      expect(remaining_time_read).to eq('25:00')
    end

    def remaining_time_read
      user.find('.remaining_time').text
    end
  end

  describe 'form' do
    before {allow(read).to receive(:all_events).with('production').and_return([])}

    it 'normal production usage' do
      expect(write).to receive(:append_events).with('production', [
          [:start_new_timer, 25 * 60, now],
      ])

      user.visit '/timer'
      user.fill_in 'duration', with: "25"
      user.click_on 'start'

      expect(user.current_path).to eq('/timer')
    end

    it 'with a=1 you can fill the start-time' do
      require 'time'
      inserted_time = Time.parse("2018-02-01T09:00")
      expect(write).to receive(:append_events).with('production', [
          [:start_new_timer, 25 * 60, inserted_time],
      ])

      user.visit '/timer?a='
      user.fill_in 'duration', with: "25"
      user.fill_in 'start-time', with: "2018-02-01T09:00"
      user.click_on 'start'

      expect(user.current_path).to eq('/timer')
    end

    describe 'shows start_time only when called with ?a=1' do
      before do
        now = Time.parse('1970-01-01 01:00:00 +0000')
        allow(clock).to receive(:now).and_return(now)
      end
      it do
        user.visit '/timer?a=1'
        expect(start_time_values).to eq(['1970-01-01 01:00:00 +0000'])
      end
      it do
        user.visit '/timer'
        expect(start_time_values).to eq([])
      end

      def start_time_values
        user.all('#start-time').map do |field|
          field[:value]
        end
      end
    end

  end


end
