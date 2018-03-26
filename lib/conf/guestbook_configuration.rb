class GuestbookConfiguration
  def initialize path, read, write
    @path = path
    @read = read
    @write = write
  end

  def configure sinatra_app
    read = @read
    write = @write
    path = @path
    sinatra_app.get path do
      earth = params['earth'] || 'production'
      signatures = []
      read.all_events(earth).each do |event|
        event_id, first, last = event
        if event_id == :guestbook_signed
          signatures << "#{first} #{last}"
        end
      end
      GuestbookPage.new(signatures, earth).to_html
    end
    sinatra_app.post path do
      earth = params['earth'] || 'production'
      first_name = params['first-name']
      last_name = params['last-name']
      write.append_events(earth, [
          [:guestbook_signed, first_name, last_name]
      ])
      redirect to(path)
    end
  end

  class GuestbookPage
    def initialize signatures, earth
      @signatures = signatures
      @earth = earth
    end

    def to_html
      <<~HTML
#{signatures_as_html}
                <form method="POST">
                   <label for="first-name">First Name:</label>
                   <input type="text" name="first-name"/> 
                   <label for="last-name">Last Name:</label>                 
                   <input type="text" name="last-name"/>
                   <input id='earth' type="hidden" name="earth" value='#{earth_html}'/>
                   <input type="submit" value="Sign!"/>
                </form>
      HTML

    end

    private
    def earth_html
      require 'cgi/util'
      CGI.escape_html @earth
    end

    def signatures_as_html
      require 'cgi/util'
      @signatures.map do |name|
        "<p class='signature'>#{CGI.escape_html name}</p>\n"
      end.join
    end

  end

end
