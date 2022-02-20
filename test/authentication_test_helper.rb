module AuthenticationTestHelper
    def authenticate!
        unless defined?(@@auth)
            puts "Authenticating" 
            @@auth ||= PcloudRuby::Auth.new(email= ENV["EMAIL"], password= ENV["PASSWORD"])
            @@auth.login
        else
            puts "Authenticating again" 
            if @@auth.list_tokens["result"] != 0
                @@auth.login
            end
        end
    end

    def auth
        @@auth
    end
end


