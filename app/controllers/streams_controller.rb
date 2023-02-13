class StreamsController < ApplicationController
  before_action :authenticate, except: %i[ index show ]
  before_action :set_stream, only: %i[ show update destroy ]

  # GET /streams
  def index
    @streams = Stream.all

    render json: @streams
  end

  # GET /streams/1
  def show
    render json: @stream
  end

  # POST /streams
  def create
   if can? :create, Stream 
       @stream = Stream.new(stream_params)

      if @stream.save
        render json: @stream, status: :created, location: @stream
      else
        render json: @stream.errors, status: :unprocessable_entity
      end
    else 
      render json: { message: 'You are not authorized to create a stream' }, status: :unauthorized
    end
  end

  # PATCH/PUT /streams/1
  def update
    if can? :update, Stream 
      if @stream.update(stream_params)
        render json: @stream
      else
        render json: @stream.errors, status: :unprocessable_entity
      end
    else 
      render json: { message: 'You are not authorized to update a stream' }, status: :unauthorized
    end
  end

  # DELETE /streams/1
  def destroy
    if can? :destroy, Stream 
      @stream.destroy
      render json: {message: "Stream deleted successfully"}
    else
      render json: { message: 'You are not authorized to delete a stream' }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream
      begin
        @stream = Stream.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Stream not found' }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def stream_params
      params.require(:stream).permit(:name, :level)
    end
end
