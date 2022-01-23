class Api::V1::ApplicationsController < ApplicationController
  before_action :load_application, only: [:show, :update]
  before_action :permitted_params, only: [:create, :update]

  def index
    applications = Application.all
    render json: {applications: applications.as_json(except: [:id])}, status: 200
  end

  def show
    render json: @application.as_json(except: [:id]), status: 200
  end

  def create
    application = Application.create(@permitted_params)
    render json: application.as_json(except: [:id]), status: 200
  end

  def update
    @application.update(@permitted_params)
    render json: @application.as_json(except: [:id]), status: 200
  end

  private

    def permitted_params
      empty_param("name") && return unless params[:name].present?
      @permitted_params = params.permit(:name)
    end

    def load_application
      @application = Application.find_by_token(params[:token])
      object_not_found("application") && return if @application.blank?
    end

end