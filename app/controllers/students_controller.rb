class StudentsController < ApplicationController
  # load_and_authorize_resource
  before_action :authenticate, only: %i[index show create update destroy]
  before_action :set_student, only: %i[show update destroy]

  # GET /students
  def index
    @students = Student.all.includes(:user, :parent, :subjects, :streams)

    modified_students = @students.map do |student|
      combined_student_user_parent_subject_stream(student, student.user, student.parent, student.subjects,
                                                  student.streams[0])
    end
    render json: modified_students
  end

  # GET /students/1
  def show
    render json: combined_student_user_parent_subject_stream(@student, @student.user, @student.parent,
                                                             @student.subjects, @student.streams[0])
  end

  # POST /students
  def create
    if can? :create, Student
      @user = User.new(user_name: student_params[:user_name], password: student_params[:password], role: 'student')

      if @user.save
        parent_user = User.find_by(user_name: student_params[:parent_user_name])

        if parent_user.nil?
          render json: { message: 'Invalid parent user_name' }, status: :not_acceptable
        else
          @parent = Parent.find_by(user_id: parent_user.id)

          @student = Student.new(trim_params(student_params).merge({ parent_id: @parent.id, user_id: @user.id }))

          if @student&.save
            token = encode_token({ user_id: @user.id })

            # add logic for adding subjects to student
            create_subject_students(@student, student_params[:subjects_ids]) unless student_params[:subjects_ids].nil?

            # add logic for adding a stream or streams to student
            create_student_stream(@student, student_params[:stream_name]) unless student_params[:stream_name].nil?

            render json: { student: combined_student_user_parent_subject_stream(@student, @user, @parent, @student.subjects, @student.streams[0]), jwt: token },
                   status: :created
          else
            render json: { message: 'Invalid student details', errors: @student.errors }, status: :not_acceptable
          end
        end

      else
        render json: { errors: @user.errors }, status: :not_acceptable
      end
    else
      render json: { message: 'You are not authorized to create a student' }, status: :forbidden
    end
  end

  # PATCH/PUT /students/1
  def update
    if can? :update, student
      @user = User.find(@student.user_id)
      @parent = Parent.find(@student.parent_id)

      @user.update_column(:user_name, student_params[:user_name]) if @user.user_name != student_params[:user_name]

      if @student.update(trim_params(student_params).merge({ parent_id: @parent.id, user_id: @user.id }))
        # add logic for adding subjects to student
        create_subject_students(@student, student_params[:subjects_ids]) unless student_params[:subjects_ids].nil?

        # add logic for adding a stream or streams to student
        create_student_stream(@student, student_params[:stream_name]) unless student_params[:stream_name].nil?

        render json: combined_student_user_parent_subject(@student, @student.user, @student.parent, @student.subjects, @student.streams[0]),
               status: :ok
      else
        render json: { errors: @student.errors }, status: :not_acceptable
      end
    else
      render json: { message: 'You are not authorized to update a student' }, status: :forbidden
    end
  end

  # DELETE /students/1
  def destroy
    if can? :destroy, Student
      @student.destroy

      render json: { message: 'Student deleted successfully' }
    else
      render json: { message: 'You are not authorized to delete a student' }, status: :forbidden
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Student not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:full_name, :sex, :date_of_birth, :contact, :physical_address,
                                    :date_of_enrollment, :parent_user_name, :user_name, :password, :stream_name, subjects_ids: [])
  end

  def combined_student_user_parent_subject_stream(student, user, parent, subjects, stream)
    modified_subjects = subjects.map(&:name)
    return if stream.nil?

    { user_name: user.user_name }.merge({ parent_user_name: parent.user.user_name }).merge(student.as_json).merge({
                                                                                                                    subjects: modified_subjects, stream: stream.name
                                                                                                                  })
  end

  def trim_params(student_params)
    student_params.except(:user_name, :password, :parent_user_name, :subjects_ids, :stream_name)
  end

  def create_subject_students(student, subject_ids)
    SubjectStudent.where(student_id: student.id).destroy_all
    subject_ids.each do |subject_id|
      SubjectStudent.create(student_id: student.id, subject_id:)
    end
  end

  def create_student_stream(student, stream_name)
    StudentStream.where(student_id: student.id).destroy_all
    stream = Stream.find_by(name: stream_name)
    StudentStream.create(student_id: student.id, stream_id: stream.id)
  end
end
