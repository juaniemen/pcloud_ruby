module PcloudRuby
    module Resources
        require 'securerandom'
        require 'mime-types'

        class File
        
            # folder_dest: Pcloud destination can be a destination string path or numeric id
            def self.upload(folder_dest, file, auth, rename_if_exists= false, progress_hash= SecureRandom.hex)
                raise Error if [folder_dest, auth, file].any?(&:nil?)
                raise Error unless auth.is_a?(PcloudRuby::Auth)
                raise Error unless file.is_a?(::File)
                raise Error if (!!rename_if_exists != rename_if_exists) # Argument error. rename_if_exists no es boolean
                params = {
                    nopartial: true,    
                    filename: ::File.basename(file.to_path),
                    progresshash: progress_hash,
                    auth: auth.token,
                    renameifexists: rename_if_exists,
                    logout: 0
                }


                if folder_dest.is_a?(Integer) || folder_dest.to_i.to_s == folder_dest
                    params.merge!({folderid: folder_dest.to_i})
                else
                    params.merge!({path: folder_dest})
                end
                
                faraday_file = Faraday::UploadIO.new(  file.to_path, 
                                                MIME::Types.type_for(file.path)
                                            )

                response = PcloudRuby::Client.post_multiform(
                    "uploadfile",
                    params.merge({file: faraday_file})
                )
                raise Error if response["result"] != 0
                response["progress_hash"] = progress_hash
                response
            end
            
            # Upload a remote file into Pcloud folder_dest
            def self.upload_remote(file_src, folder_dest, auth, async= false)
                raise Error if [file_src, auth].any?(&:nil?)
                raise Error unless auth.is_a?(PcloudRuby::Auth)
                raise Error if (!!async != async) # Argument error. rename_if_exists no es boolean
                params = {
                    url: file_src,
                    path: folder_dest,
                    auth: auth.token,
                    logout: 0
                }

                if folder_dest.is_a?(Integer) || folder_dest.to_i.to_s == folder_dest
                    params.merge!({folderid: folder_dest.to_i})
                else
                    params.merge!({path: folder_dest})
                end
                
                response = PcloudRuby::Client.get(
                    "downloadfile",
                    params
                )
                raise Error if response["result"] != 0
                response
            end
            
            
            def self.download(file_src, file_dest, auth)
                raise Error if [file_src, auth].any?(&:nil?)
                raise Error unless auth.is_a?(PcloudRuby::Auth)

                params = {
                    path: file_src,
                    auth: auth.token,
                    logout: 0
                }

                if file_src.is_a?(Integer) || file_src.to_i.to_s == file_src
                    params.merge!({fileid: file_src.to_i})
                else
                    params.merge!({path: file_src})
                end
                
                filelink = Client.get(
                    "getfilelink",
                    params
                )
                response = Faraday.get("https://" + filelink['hosts'][0] + filelink["path"], params)
                ::File.open(file_dest, 'wb') { |fp| fp.write(response.body) }
                response
            end


            def self.check_upload_progress(hash, auth)
                raise Error if [hash, auth].any?(&:nil?)
                raise Error unless auth.is_a?(PcloudRuby::Auth)

                params = {  progresshash: hash,
                            auth: auth.token
                            }

                response = Client.get(
                    "uploadprogress",
                    params
                )
                raise Error if response["result"] != 0
                response
            end

            def self.delete(file_src, auth)
                raise Error if [file_src, auth].any?(&:nil?)
                raise Error unless auth.is_a?(PcloudRuby::Auth)

                params = {
                    path: file_src,
                    auth: auth.token,
                    logout: 0
                }

                if file_src.is_a?(Integer) || file_src.to_i.to_s == file_src
                    params.merge!({fileid: file_src.to_i})
                else
                    params.merge!({path: file_src})
                end
                
                response = Client.get(
                    "deletefile",
                    params
                )
                raise Error if response["result"] != 0
                response
            end

            def self.rename(file_src, file_dest, auth)
                raise Error if [file_src, file_dest, auth].any?(&:nil?)
                raise Error if [file_src, file_dest].any?{|m| m[-1] == "/"}
                raise Error unless auth.is_a?(PcloudRuby::Auth)

                params = {
                    path: file_src,
                    auth: auth.token,
                    logout: 0
                }

                if file_src.is_a?(Integer) || file_src.to_i.to_s == file_src
                    params.merge!({fileid: file_src.to_i})
                else
                    params.merge!({path: file_src})
                end

                if file_dest.is_a?(Integer) || file_dest.to_i.to_s == file_dest
                    params.merge!({folderid: file_dest.to_i})
                else
                    params.merge!({topath: file_dest})
                end
                
                response = Client.get(
                    "renamefile",
                    params
                )            
                raise Error if response["result"] != 0
                response
            end

        end
    end
end
