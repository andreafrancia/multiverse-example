class FakePstore
  def self.make
    store = Hash.new
    def store.transaction
      yield
    end
    store
  end
end
