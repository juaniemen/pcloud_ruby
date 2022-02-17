module PcloudRuby
    require 'rest-client'
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

        def self.get(resource_url, **kwargs)
            response = RestClient.get(URI.join(self.root_url, resource_url).to_s, **kwargs).body
            JSON.parse(response)
        end

        def self.post(resource_url, **kwargs)
            response = RestClient.post(URI.join(self.root_url, resource_url).to_s, **kwargs)
            JSON.parse(response)
        end

    end

end
