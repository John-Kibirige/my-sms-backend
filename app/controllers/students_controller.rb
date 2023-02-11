class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show update destroy ]

  # GET /students
  def index
    @students = Student.all.includes(:user, :parent)
    modified_students = @students.map do |student| 
      combined_student_user_parent(student, student.user, student.parent)
    end
    render json: modified_students
  end

  # GET /students/1
  def show
    render json: combined_student_user_parent(@student, @student.user, @student.parent)
  end

  # POST /students
  def create
    @user = User.new(user_name: student_params[:user_name], password: student_params[:password], role: 'student')

    if @user.save 
      parent_user = User.find_by(user_name: student_params[:parent_user_name])

      if parent_user != nil 
        @parent = Parent.find_by(user_id: parent_user.id)

        @student = Student.new(trim_params(student_params).merge({parent_id: @parent.id, user_id: @user.id}))

        if @student && @student.save
          token = encode_token({ user_id: @user.id })
          render json: { student: combined_student_user_parent(@student, @user, @parent), token: token }, status: :created
        else
          render json: { message: 'Invalid student details', errors: @student.errors }, status: :not_acceptable
        end
      else
        render json: { message: 'Invalid parent user_name'}, status: :not_acceptable
      end

    else
      render json: { errors: @user.errors }, status: :not_acceptable
    end
  end

  # PATCH/PUT /students/1
  def update
    @user = User.find(@student.user_id)
    if @user.user_name != student_params[:user_name]
      @user.update_column(:user_name, student_params[:user_name])
    end

    if @student.update(trim_params(student_params).merge({parent_id: @parent.id, user_id: @user.id}))
      render json: combined_student_user_parent(@student, @student.user, @student.parent), status: :ok
    else
      render json: { errors: @student.errors }, status: :not_acceptable
    end
  end

  # DELETE /students/1
  def destroy
    @user = @student.user

    @student.destroy
    @user.destroy
  
    render json: { message: 'Student deleted successfully'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      begin
        @student = Student.find(params[:id])
      rescue ActiveRecord::RecordNotFound 
        render json: { message: 'Student not found'}, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:full_name, :sex, :date_of_birth, :contact, :physical_address, :date_of_enrollment, :parent_user_name, :user_name, :password)
    end

    def combined_student_user_parent(student, user, parent)
      {user_name: user.user_name}.merge({parent_user_name: parent.user.user_name}).merge(student.as_json)
    end

    def trim_params(student_params)
      student_params.except(:user_name, :password, :parent_user_name)
    end
end
