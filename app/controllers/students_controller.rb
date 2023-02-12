class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show update destroy ]

  # GET /students
  def index
    @students = Student.all.includes(:user, :parent)
    modified_students = @students.map do |student| 
      combined_student_user_parent_subject(student, student.user, student.parent, student.subjects)
    end
    render json: modified_students
  end

  # GET /students/1
  def show
    render json: combined_student_user_parent_subject(@student, @student.user, @student.parent, @student.subjects)
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

          # add logic for adding subjects to student
          create_subject_students(@student, student_params[:subjects_ids]) unless student_params[:subjects_ids].nil?

          render json: { student: combined_student_user_parent_subject(@student, @user, @parent, @student.subjects), jwt: token }, status: :created

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
    @parent = Parent.find(@student.parent_id)

    if @user.user_name != student_params[:user_name]
      @user.update_column(:user_name, student_params[:user_name])
    end

    if @student.update(trim_params(student_params).merge({parent_id: @parent.id, user_id: @user.id}))
       # add logic for adding subjects to student
       create_subject_students(@student, student_params[:subjects_ids]) unless student_params[:subjects_ids].nil?

      render json: combined_student_user_parent_subject(@student, @student.user, @student.parent, @student.subjects), status: :ok
    else
      render json: { errors: @student.errors }, status: :not_acceptable
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
  
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
      params.require(:student).permit(:full_name, :sex, :date_of_birth, :contact, :physical_address, :date_of_enrollment, :parent_user_name, :user_name, :password, :subjects_ids => [])
    end

    def combined_student_user_parent_subject(student, user, parent, subjects)
      modified_subjects = subjects.map do |subject| 
        subject.name
      end
      {user_name: user.user_name}.merge({parent_user_name: parent.user.user_name}).merge(student.as_json).merge({subjects: modified_subjects})
    end

    def trim_params(student_params)
      student_params.except(:user_name, :password, :parent_user_name, :subjects_ids)
    end

    def create_subject_students(student, subject_ids)
      SubjectStudent.where(student_id: student.id).destroy_all
      subject_ids.each do |subject_id|
        SubjectStudent.create(student_id: student.id, subject_id: subject_id)
      end
    end
end
