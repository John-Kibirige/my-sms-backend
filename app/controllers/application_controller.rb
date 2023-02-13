class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'st-mark-secret')
  end

  def decode_token
    auth_header = request.headers['Authorization']

    return unless auth_header

    token = auth_header.split.last
    begin
      JWT.decode(token, 'st-mark-secret', true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def authenticate_user
    decoded_token = decode_token

    return unless decoded_token
    # add logic for checking if the token is in the invalid tokens table

    user_id = decoded_token[0]['user_id']
    @current_user = User.find_by(id: user_id)
  end

  def authenticate
    render json: { message: 'Please log in first' } unless authenticate_user
  end

  attr_reader :current_user
end
