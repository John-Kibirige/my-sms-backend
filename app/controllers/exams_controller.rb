class ExamsController < ApplicationController
  before_action :authenticate
  before_action :set_exam, only: %i[ show update destroy ]

  # GET /exams
  def index
    @exams = Exam.where(subject_id: params[:subject_id])

    render json: @exams
  end

  # GET /exams/1
  def show
    render json: @exam
  end

  # POST /exams
  def create
    if can? :create, Exam
      @exam = Exam.new(exam_params.merge({subject_id: params[:subject_id]}))

      if @exam.save
        render json: @exam, status: :created
      else
        render json: @exam.errors, status: :unprocessable_entity
      end
    else 
      render json: { message: 'You are not authorized to create an exam' }, status: :unauthorized
    end
  end

  # PATCH/PUT /exams/1
  def update
    if can? :update, Exam 
      if @exam.update(exam_params)
        render json: @exam
      else
        render json: @exam.errors, status: :unprocessable_entity
      end
    else 
      render json: { message: 'You are not authorized to update an exam' }, status: :unauthorized
    end
  end

  # DELETE /exams/1
  def destroy
    if can? :destroy, Exam
      @exam.destroy
      render json: { message: 'Exam deleted successfully'}
    else 
      render json: { message: 'You are not authorized to delete an exam' }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      begin
        @exam = Exam.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Exam not found' }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def exam_params
      params.require(:exam).permit(:name, :date, :term)
    end
end
