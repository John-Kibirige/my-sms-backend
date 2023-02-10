class UsersController < ApplicationController
  def login
    @user = User.find_by(user_name: params[:user_name])

    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private 

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
