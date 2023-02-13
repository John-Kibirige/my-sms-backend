class ApplicationController < ActionController::API
    def encode_token(payload)
        JWT.encode(payload, 'st-mark-secret')
    end

    def decode_token
        auth_header = request.headers['Authorization']

        if auth_header 
            token = auth_header.split(' ').last

            if InvalidToken.find_by(name: token).nil?
                 begin
                    JWT.decode(token, 'st-mark-secret', true, algorithm: 'HS256')
                rescue JWT::DecodeError
                    nil
                end
            else
                nil
            end
        end   
    end

    def authenticate_user 
        decoded_token = decode_token()

        if decoded_token 
            user_id = decoded_token[0]['user_id']
            @current_user = User.find_by(id: user_id)
        else
            nil
        end
    end

    def authenticate 
        render json: { message: 'Please log in first' } unless authenticate_user
    end

    def current_user 
        @current_user
    end
end
