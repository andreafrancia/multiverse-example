require 'puts_repo'

describe PutsRepo do
  subject(:repo) { PutsRepo.new(stdout) }
  let(:stdout) { StringIO.new }

  it do
    repo.start_new_timer(25, double(to_s:'time'))

    expect(stdout.string.chomp).to eq('Started timer of 25 at time')
  end

end
