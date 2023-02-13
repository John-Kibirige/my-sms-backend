class SubjectsController < ApplicationController
  before_action :authenticate, only: %i[index show create update destroy]
  before_action :set_subject, only: %i[show update destroy]

  # GET /subjects
  def index
    @subjects = Subject.all

    render json: @subjects
  end

  # GET /subjects/1
  def show
    render json: @subject
  end

  # POST /subjects
  def create
    if can? :create, Subject
      @subject = Subject.new(subject_params)

      if @subject.save
        render json: @subject, status: :created, location: @subject
      else
        render json: @subject.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to create a subject' }, status: :forbidden
    end
  end

  # PATCH/PUT /subjects/1
  def update
    if can? :update, Subject
      if @subject.update(subject_params)
        render json: @subject
      else
        render json: @subject.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to update a subject' }, status: :forbidden
    end
  end

  # DELETE /subjects/1
  def destroy
    if can? :destroy, Subject
      @subject.destroy
      render json: { message: 'subject deleted successfully' }
    else
      render json: { message: 'You are not authorized to delete a subject' }, status: :forbidden
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject
    @subject = Subject.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Subject not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def subject_params
    params.require(:subject).permit(:name, :tag, :level, :category, :description)
  end
end
