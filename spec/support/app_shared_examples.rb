RSpec.shared_examples App do
  specify 'whole workflow' do
    earth="test-#{Time.now.to_f}"
    user.visit "/?earth=#{earth}"
    expect(user.text).to eq('not started')

    user.visit "/new?a=1&earth=#{earth}"
    user.fill_in 'duration', with: 10
    user.fill_in 'start-time', with: '2018-03-25T16:00:00'
    user.click_on

    user.visit "/?now=2018-03-25T16:00:00&earth=#{earth}"
    expect(user.find('.remaining_time').text).to eq('10:00')
    user.visit "/?now=2018-03-25T16:00:01&earth=#{earth}"
    expect(user.find('.remaining_time').text).to eq('09:59')
  end
end

