class AdminsController < ApplicationController
  def create
    @user = User.new(user_name: admin_params[:user_name], password: admin_params[:password], role: 'admin')

    if @user.save 
      # add logic for creating admin
      @admin = Admin.new(trim_params(admin_params).merge({user_id: @user.id}))

      if @admin.save 
        token = encode_token({ user_id: @user.id })
        render json: { admin: combined_admin_user(@admin, @user), token: token }, status: :created 
      else 
        render json: { message: 'Invalid admin details' }, status: :not_acceptable
      end
    else
      render json: { errors: @user.errors }, status: :not_acceptable
    end
  end                          

  private 

  def admin_params 
    params.require(:admin).permit(:full_name, :sex, :contact, :email, :user_name, :password)
  end

  def combined_admin_user(admin, user)
    admin.as_json.merge({user_name: user.user_name, password: user.password})
  end

  def trim_params 
    admin_params.except(:user_name, :password)
  end
end
