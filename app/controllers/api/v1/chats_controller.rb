class Api::V1::ChatsController < ApplicationController
  before_action :load_application, only: [:index, :create]
  before_action :load_chat, only: [:show, :update]
  before_action :permitted_params, only: [:create, :update]

  def index
    chats = @application.chats
    render json: {chats: chats.as_json(except: [:id])}, status: 200
  end

  def show
    render json: @chat.as_json(except: [:id]), status: 200
  end

  def create
    @application.chat_counter.increment do |chat_number|
      CreateChatWorker.perform_async(@application.token, chat_number, @permitted_params[:name])
      render json: {chat_number: chat_number}, status: 200
    end
  end

  def update
    @chat.update(@permitted_params)
    render json: {chat: @chat.as_json(except: [:id])}, status: 200
  end

  private

    def permitted_params
      empty_param("name") && return unless params[:name].present?
      @permitted_params = params.permit(:name)
    end

    def load_application
      @application = Application.find_by_token(params[:application_token])
      object_not_found("application") && return if @application.blank?
    end

    def load_chat
      @chat = Chat.find_by(app_token: params[:application_token], chat_number: params[:number])
      object_not_found("chat") && return if @chat.blank?
    end

end