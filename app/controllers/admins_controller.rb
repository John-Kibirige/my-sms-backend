class AdminsController < ApplicationController
  def create
    @user = User.new(user_name: admin_params[:user_name], password: admin_params[:password], role: 'admin')

    if @user.save 
      # add logic for creating admin
      @admin = Admin.new(full_name: admin_params[:full_name], sex: admin_params[:sex], contact: admin_params[:contact], email: admin_params[:email], user_id: @user.id)

      if @admin.save 
        token = encode_token({ user_id: @user.id })
        render json: { admin: combined_admin_user(@admin, @user), token: token }, status: :created 
      else 
        render json: { message: 'Invalid admin details' }, status: :not_acceptable
      end
    else@user.errors.messages
      render json: { message: @user.errors.messages }, status: :not_acceptable
    end
  end                          

  private 

  def admin_params 
    params.require(:admin).permit(:full_name, :sex, :contact, :email, :user_name, :password)
  end

  def combined_admin_user(admin, user)
  {
    id: admin.id,
    user_name: user.user_name,
    password: user.password,
    full_name: admin.full_name,
    contact: admin.contact,
    sex: admin.sex,
    email: admin.email,
  }
  end
end
