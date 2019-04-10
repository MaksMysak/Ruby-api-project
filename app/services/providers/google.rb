require 'net/http'

module Providers
  class Google
    def self.get_data(token)
      path = "https://www.googleapis.com/oauth2/v1/tokeninfo"
      params = {
        access_token: token
      }
      uri = URI("#{path}?#{params.to_query}")
  
      response = ::Net::HTTP.get_response(uri)
      data = JSON.parse(response.body)
    end
  end
end