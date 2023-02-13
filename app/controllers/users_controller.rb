class UsersController < ApplicationController
  def login
    @user = User.find_by(user_name: params[:user_name])

    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def logout 
    auth_header = request.headers['Authorization']
    return unless auth_header

    token = auth_header.split.last
    InvalidToken.create(name: token)

    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
