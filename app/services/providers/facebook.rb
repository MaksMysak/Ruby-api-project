require 'net/http'

module Providers
  class Facebook
    def self.get_data(token)
      path = "https://graph.facebook.com/v3.2/me"
      params = {
        access_token: token,
        fields: "email, name"
      }
      uri = URI("#{path}?#{params.to_query}")
  
      response = ::Net::HTTP.get_response(uri)
      data = JSON.parse(response.body)
    end
  end
end