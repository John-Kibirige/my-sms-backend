class TeachersController < ApplicationController
  before_action :authenticate, except: %i[index show]
  before_action :set_teacher, only: %i[show update destroy]

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
      @teacher = Teacher.new(trim_params(teacher_params).merge({ user_id: @user.id }))

      if @teacher.save
        token = encode_token({ user_id: @user.id })

        # add logic for adding subjects to teacher
        create_subject_teachers(@teacher, teacher_params[:subjects_ids]) unless teacher_params[:subjects_ids].nil?
        render json: { teacher: combined_teacher_user_subject(@teacher, @user, @teacher.subjects), jwt: token },
               status: :created

      else
        render json: { message: 'Invalid teacher details', errors: @teacher.errors }, status: :not_acceptable
      end
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teachers/1
  def update
    @user = User.find(@teacher.user_id)
    @user.update_column(:user_name, teacher_params[:user_name]) if @user.user_name != teacher_params[:user_name]

    if @teacher.update(trim_params(teacher_params).merge({ user_id: @user.id }))
      # add logic for updating subjects to teacher
      create_subject_teachers(@teacher, teacher_params[:subjects_ids]) unless teacher_params[:subjects_ids].nil?

      render json: combined_teacher_user_subject(@teacher, @teacher.user, @teacher.subjects), status: :ok
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
    @teacher = Teacher.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Teacher not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def teacher_params
    params.require(:teacher).permit(:full_name, :contact, :email, :physical_address, :sex, :joining_date, :user_name,
                                    :password, subjects_ids: [])
  end

  def combined_teacher_user_subject(teacher, user, subjects)
    modified_subjects = subjects.map(&:name)
    { user_name: user.user_name }.merge(teacher.as_json).merge({ subjects: modified_subjects })
  end

  def trim_params(teacher_params)
    teacher_params.except(:user_name, :password, :subjects_ids)
  end

  def create_subject_teachers(teacher, subjects_ids)
    subjects_ids.each do |subject_id|
      unless SubjectTeacher.find_by(teacher_id: teacher.id, subject_id:).present?
        SubjectTeacher.create(teacher_id: teacher.id, subject_id:)
      end
    end
  end
end
