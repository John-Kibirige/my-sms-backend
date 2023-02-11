class ParentsController < ApplicationController
  before_action :set_parent, only: %i[ show update destroy ]

  # GET /parents
  def index
    @parents = Parent.all.includes(:user)
    modified_parents = @parents.map do |parent| 
      combined_parent_user(parent, parent.user)
    end

    render json: modified_parents
  end

  # GET /parents/1
  def show
    render json: combined_parent_user(@parent, @parent.user)
  end

  # POST /parents
  def create
    @user = User.new(user_name: parent_params[:user_name], password: parent_params[:password], role: 'parent')

    if @user.save 
      @parent = Parent.new(trim_params(parent_params).merge({user_id: @user.id}))

      if @parent.save 
        token = encode_token({ user_id: @user.id })
        render json: { parent: combined_parent_user(@parent, @user), token: token }, status: :created
      else
        render json: { message: 'Invalid parent details', errors: @parent.errors }, status: :not_acceptable
      end
    else 
      render json: {errors:  @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /parents/1
  def update
    @user = User.find(@parent.user_id)
    if @user.user_name != parent_params[:user_name] 
      @user.update_column(:user_name, parent_params[:user_name])
    end

    if @parent.update(trim_params(parent_params).merge({user_id: @user.id}))
      render json: combined_parent_user(@parent, @parent.user), status: :ok
    else 
      render json: {errors:  @parent.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /parents/1
  def destroy
    @parent.destroy
    User.find(@parent.user_id).destroy
  
    render json:{ message: 'Parent deleted successfully'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent
      begin
        @parent = Parent.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Parent not found', }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def parent_params
      params.require(:parent).permit(:full_name, :contact, :physical_address, :sex, :number_of_students, :user_name, :password)
    end

    def combined_parent_user(parent, user)
      {user_name: user.user_name}.merge(parent.as_json)
    end

    def trim_params(parent_params)
      parent_params.except(:user_name, :password)
    end
end
