module AnAppWithAGuestbook; end
RSpec.shared_examples AnAppWithAGuestbook do
  require 'support/read_signatures'
  before { user.extend ReadSignatures}

  earth = "test-#{Time.now.to_f}"

  it "starts with no signatures" do
    user.visit "/guestbook?earth=#{earth}"
    expect(user.signatures_read).to eq([])
  end

  it 'can be signed' do
    user.visit "/guestbook?earth=#{earth}"

    sign_as 'Mark', 'Milton'
    sign_as 'Clark', 'Kent'

    expect(user.current_path).to eq('/guestbook')
    expect(user.signatures_read).to eq(["Mark Milton",
                                        "Clark Kent"])
  end

  def sign_as first_name, last_name
    user.fill_in "first-name", with:first_name
    user.fill_in "last-name", with:last_name
    user.click_on
  end

end

