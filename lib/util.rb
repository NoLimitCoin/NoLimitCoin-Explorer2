# General utility methods for application
# Author: Sambhav Sharma
class Util

  class << self


    # Pulls browser information from HTTP_USER_AGENT request header
    #
    # Author:: Sambhav Sharma
    # Date:: 14/06/2016
    # Reviewed By::
    #
    # Params:
    # +http_user_agent+:: HTTP_USER_AGENT header for the request
    #
    def detect_browser(http_user_agent)
      result = http_user_agent
      if result =~ /Safari/
        if result =~ /Chrome/
          version = result.split('Chrome/')[1].split(' ').first.split('.').first
          browser = 'Chrome'
        else
          browser = 'Safari'
          version = result.split('Version/')[1].split(' ').first.split('.').first
        end
      elsif result =~ /Firefox/
        browser = 'Firefox'
        version = result.split('Firefox/')[1].split('.').first
      elsif result =~ /Opera/
        browser = 'Opera'
        version = result.split('Version/')[1].split('.').first
      elsif result =~ /MSIE/
        browser = 'MSIE'
        version = result.split('MSIE')[1].split(' ').first
      else
        browser = nil
        version = nil
      end

      [browser,version]
    end

  end
end
