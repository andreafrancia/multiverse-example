module AnAppWithATimer; end
RSpec.shared_examples AnAppWithATimer do
  earth="test-#{Time.now.to_f}"

  specify "whole workflow, earth=#{earth}" do
    user.visit "/timer?earth=#{earth}"
    expect(user.text).to eq('not started')

    user.visit "/timer?a=1&earth=#{earth}"
    user.fill_in 'duration', with: 10
    user.fill_in 'start-time', with: '2018-03-25T16:00:00'
    user.click_on

    user.visit "/timer?now=2018-03-25T16:00:00&earth=#{earth}"
    expect(user.find('.remaining_time').text).to eq('10:00')
    user.visit "/timer?now=2018-03-25T16:00:01&earth=#{earth}"
    expect(user.find('.remaining_time').text).to eq('09:59')
  end
end

