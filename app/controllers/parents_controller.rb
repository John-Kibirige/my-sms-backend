class ParentsController < ApplicationController
  before_action :authenticate, except: %i[index show]
  before_action :set_parent, only: %i[show update destroy]

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
    if can? :create, Parent
      @user = User.new(user_name: parent_params[:user_name], password: parent_params[:password], role: 'parent')

      if @user.save
        @parent = Parent.new(trim_params(parent_params).merge({ user_id: @user.id }))

        if @parent.save
          token = encode_token({ user_id: @user.id })
          render json: { parent: combined_parent_user(@parent, @user), token: }, status: :created
        else
          render json: { message: 'Invalid parent details', errors: @parent.errors }, status: :not_acceptable
        end
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to create a parent' }, status: :unauthorized
    end
  end

  # PATCH/PUT /parents/1
  def update
    if can? :update, Parent
      @user = User.find(@parent.user_id)
      @user.update_column(:user_name, parent_params[:user_name]) if @user.user_name != parent_params[:user_name]

      if @parent.update(trim_params(parent_params).merge({ user_id: @user.id }))
        render json: combined_parent_user(@parent, @parent.user), status: :ok
      else
        render json: { errors: @parent.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to update a parent' }, status: :unauthorized
    end
  end

  # DELETE /parents/1
  def destroy
    if can? :destroy, Parent
      @user = @parent.user
      @parent.destroy
      @user.destroy

      render json: { message: 'Parent deleted successfully' }
    else
      render json: { message: 'You are not authorized to delete a parent' }, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parent
    @parent = Parent.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Parent not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def parent_params
    params.require(:parent).permit(:full_name, :contact, :physical_address, :sex, :number_of_students, :user_name,
                                   :password)
  end

  def combined_parent_user(parent, user)
    { user_name: user.user_name }.merge(parent.as_json)
  end

  def trim_params(parent_params)
    parent_params.except(:user_name, :password)
  end
end
