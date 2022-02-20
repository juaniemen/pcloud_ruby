module PcloudRuby
    require "digest"

    class Auth
        attr_accessor :digest
        attr_reader :username, :token, :token_id
        
        def initialize(email, password)
            @username = email
            @password = password
        end

        # No plain password will travel abroad the internet
        # So we get a digest to handle oauth
        def get_digest
            response = Client.get("getdigest")
            raise Error if response["result"] != 0
            self.digest= response["digest"]
        end
        
        # passworddigest = sha1( password + sha1( lowercase of username ) + digest)
        def getpassword_digest
            sha1username = Digest::SHA1.hexdigest(username.downcase)
            Digest::SHA1.hexdigest(@password + sha1username + self.digest)
        end

        def login
            get_digest if self.digest.nil?
            params = { username: username,
                        digest: digest,
                        passworddigest: getpassword_digest,
                        getauth: 1,
                        logout: 0
                    }
            
            response = Client.get("userinfo", params)
            raise Error if response["result"] != 0
            @token = response["auth"]
            response
        end

        def logout
            raise Error unless self.token
            params = { token: token, auth: token }
            
            response = Client.get("logout", params)
            raise Error if response["result"] != 0
            response
        end


        def list_tokens
            raise Error unless self.token
            params = { username: username, token: self.token, logout: 0, auth: self.token}
            response = Client.get("listtokens", params)

            response
        end

        def delete_ruby_tokens
            token_ids = list_tokens["tokens"].select do |m| 
                m["device"].include?("ruby") && 
                !m["current"] # No current session
            end.map{|m| m["tokenid"]}

            token_ids.each do |token_id|
                params = { tokenid: token_id, auth: token, logout: 1 }
            
                response = Client.get("deletetoken", params)
                raise Error if response["result"] != 0
                response
            end
        end

    end
end
  