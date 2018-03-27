module AnAppWithATimerSimple; end
RSpec.shared_examples AnAppWithATimerSimple do
  specify "start a timer" do
    user.visit "/timer"
    expect(user.find('.remaining_time').text).to eq('Rang!')

    user.visit "/timer"
    user.fill_in 'duration', with: 10
    user.click_on

    user.visit "/timer"
    expect(user.find('.remaining_time').text).to eq('10:00')
  end
end

