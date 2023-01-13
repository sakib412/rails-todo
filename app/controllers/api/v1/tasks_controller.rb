class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]
  before_action :authorize_request

  # GET /tasks
  def index
    @tasks = Task.includes(:user).where(user_id: @current_user.id).order(created_at: :desc)

    render json: @tasks
  end

  # GET /tasks/1
  # def show
  #   render json: @task
  # end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user.id
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.user_id != @current_user.id
      render json: { errors: 'You are not authorized to update this task' },
             status: :unauthorized
    elsif @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    if @task.user_id != @current_user.id
      render json: { errors: 'You are not authorized to delete this task' },
             status: :unauthorized
    else
      @task.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Task not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :status)
  end
end
