class ResultsController < ApplicationController
  before_action :authenticate, except: %i[index show]
  before_action :set_result, only: %i[show update destroy]

  # GET /results
  def index
    @results = Result.all

    render json: @results
  end

  # GET /results/1
  def show
    render json: @result
  end

  # POST /results
  def create
    if can? :create, Result
      @result = Result.new(result_params)

      if @result.save
        render json: @result, status: :created, location: @result
      else
        render json: @result.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to create a result' }, status: :unauthorized
    end
  end

  # PATCH/PUT /results/1
  def update
    if can? :update, Result
      if @result.update(result_params)
        render json: @result
      else
        render json: @result.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'You are not authorized to update a result' }, status: :unauthorized
    end
  end

  # DELETE /results/1
  def destroy
    if can? :destroy, Result
      @result.destroy
      render json: { message: 'Result deleted successfully' }
    else
      render json: { message: 'You are not authorized to delete a result' }, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_result
    @result = Result.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def result_params
    params.require(:result).permit(:exam_id, :student_id, :mark)
  end
end
