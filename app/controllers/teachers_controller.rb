class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show update destroy ]

  # GET /teachers
  def index
    @teachers = Teacher.all

    render json: @teachers
  end

  # GET /teachers/1
  def show
    render json: @teacher
  end

  # POST /teachers
  def create
    @user = User.new(user_name: teacher_params[:user_name], password: teacher_params[:password], role: 'teacher')

    if @user.save
      @teacher = Teacher.new(full_name: teacher_params[:full_name], sex: teacher_params[:sex], contact: teacher_params[:contact], email: teacher_params[:email], user_id: @user.id, physical_address: teacher_params[:physical_address], joining_date: teacher_params[:joining_date])

      if @teacher.save
        token = encode_token({ user_id: @user.id })
        render json: { teacher: combined_teacher_user(@teacher, @user), token: token }, status: :created
      else
        render json: { message: 'Invalid teacher details' }, status: :not_acceptable
      end
    else
      render json: {errors:  @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teachers/1
  def update
    if @teacher.update(teacher_params)
      render json: @teacher
    else
      render json: @teacher.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teachers/1
  def destroy
    @teacher.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:full_name, :contact, :email, :physical_address, :sex, :joining_date, :user_name, :password)
    end

    def combined_teacher_user(teacher, user)
      {
        id: teacher.id,
        user_name: user.user_name,
        password: user.password,
        full_name: teacher.full_name,
        contact: teacher.contact,
        email: teacher.email,
        physical_address: teacher.physical_address,
        sex: teacher.sex,
        joining_date: teacher.joining_date,
      }
    end
end
