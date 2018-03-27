class UrlWithEarth
  def initialize path, earth
    @path = path
    @earth = earth
  end
  def to_url
    require 'uri'
    query = if @earth == 'production'
              ''
            else
              "?#{URI.encode_www_form('earth'=>@earth)}"
            end
    "#{@path}#{query}"
  end
end
