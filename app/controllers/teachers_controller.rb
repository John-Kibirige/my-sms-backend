class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show update destroy ]

  # GET /teachers
  def index
    @teachers = Teacher.all.includes(:user)
    modified_teachers = @teachers.map do |teacher| 
      combined_teacher_user(teacher, teacher.user)
    end
    
    render json: modified_teachers
  end

  # GET /teachers/1
  def show
    render json: combined_teacher_user(@teacher, @teacher.user)
  end

  # POST /teachers
  def create
    @user = User.new(user_name: teacher_params[:user_name], password: teacher_params[:password], role: 'teacher')

    if @user.save
      @teacher = Teacher.new(trim_params(teacher_params).merge{user_id: @user.id})

      if @teacher.save
        token = encode_token({ user_id: @user.id })
        render json: { teacher: combined_teacher_user(@teacher, @user), token: token }, status: :created
      else
        render json: { message: 'Invalid teacher details', errors: @teacher.errors }, status: :not_acceptable
      end
    else
      render json: {errors:  @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teachers/1
  def update
    @user = User.find(@teacher.user_id)
    if @user.user_name != teacher_params[:user_name]
      @user.update_column(:user_name, teacher_params[:user_name])
    end

    if @teacher.update(trim_params(teacher_params).merge{user_id: @user.id}) 
      render json: combined_teacher_user(@teacher, @teacher.user), status: :ok
    else 
      render json: @teacher.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teachers/1
  def destroy
    @user = @teacher.user
    @teacher.destroy
    @user.destroy

    render json: { message: 'Teacher deleted successfully' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      begin
        @teacher = Teacher.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Teacher not found' }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:full_name, :contact, :email, :physical_address, :sex, :joining_date, :user_name, :password)
    end

    def combined_teacher_user(teacher, user)
      {user_name: user.user_name}.merge(teacher.as_json)
    end

    def trim_params(teacher_params)
      teacher_params.except(:user_name, :password)
    end
end
