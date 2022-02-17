module AuthenticationTestHelper
    def authenticate!
        puts "Authenticating"
        @@auth ||= PcloudRuby::Auth.new(email= ENV["EMAIL"], password= ENV["PASSWORD"])
        @@auth.login
    end

    def auth
        @@auth
    end

end


