module PcloudRuby
    require 'faraday'
    require 'json'
    require 'uri'

    API_URL = {
        "US" => "https://api.pcloud.com",
        "EU" => "https://eapi.pcloud.com"
    }
    LOCATION = "EU"

    class Client

        def self.root_url
            API_URL[LOCATION]
        end

        def self.get(resource_url, params={})
            response = Faraday.get(URI.join(self.root_url, resource_url).to_s, params).body
            JSON.parse(response)
        end

        def self.post(resource_url, params=nil, headers=nil)
            response = Faraday.post(URI.join(self.root_url, resource_url).to_s, params, headers).body
            JSON.parse(response)
        end

        def self.post_multiform(resource_url, params)
            conn = Faraday.new(self.root_url) do |f|
                f.request :multipart
                f.request :json
                f.request :token_auth, params[:auth]
                f.adapter :net_http
              end
              
              response = conn.post(resource_url, params).body
              JSON.parse(response)
        end

    end

end
