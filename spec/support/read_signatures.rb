module ReadSignatures
  def signatures_read
    all('.signature').map(&:text)
  end
end