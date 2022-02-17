module PcloudRuby
    require "digest"

    class Auth
        attr_accessor :digest
        attr_reader :username, :password, :token, :token_id
        
        def initialize(email, password)
            @username = email
            @password = password
        end

        # No plain password will travel abroad the internet
        # So we get a digest to handle oauth
        def get_digest
            response = PcloudRuby::Client.get("getdigest")
            
            raise Error if response["result"] != 0
            self.digest= response["digest"]
        end
        
        # passworddigest = sha1( password + sha1( lowercase of username ) + digest)
        def getpassword_digest
            sha1username = Digest::SHA1.hexdigest(username.downcase)
            Digest::SHA1.hexdigest(password + sha1username + self.digest)
        end

        def login
            get_digest
            params = { username: username,
                        digest: digest,
                        passworddigest: getpassword_digest,
                        getauth: 1,
                        logout: 0
                    }

            response = PcloudRuby::Client.get("userinfo", :params => params)
            raise Error if response["result"] != 0
            @token = response["auth"]
            response
        end

        def logout
            raise Error unless self.token
            params = { token: token, auth: token }
            
            response = PcloudRuby::Client.get("logout", :params => params)
            raise Error if response["result"] != 0
            response
        end


        def list_tokens
            raise Error unless self.token
            params = { username: username, token: self.token, logout: 0, auth: self.token}
            response = PcloudRuby::Client.get("listtokens", :params => params)

            response
        end

        def delete_ruby_tokens
            token_ids = list_tokens["tokens"].select do |m| 
                m["device"].include?("ruby") && 
                m["device"].include?("rest-client") &&
                !m["current"] # No current session
            end.map{|m| m["tokenid"]}

            token_ids.each do |token_id|
                params = { tokenid: token_id, auth: token }
            
                response = PcloudRuby::Client.get("deletetoken", :params => params)
                raise Error if response["result"] != 0
                response
            end
        end

    end
end
  