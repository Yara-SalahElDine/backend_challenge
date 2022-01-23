class Api::V1::MessagesController < ApplicationController
  before_action :load_chat, only: [:index, :create]
  before_action :load_message, only: [:show, :update]
  before_action :permitted_params, only: [:create, :update]

  def index
    messages = @chat.messages
    render json: {messages: messages.as_json(:except => [:id])}, status: 200
  end

  def show
    render json: {message: @message.as_json(:except => [:id])}, status: 200
  end

  def create
    @chat.message_counter.increment do |message_number|
      CreateMessageWorker.perform_async(@chat.app_token, @chat.chat_number, message_number, @permitted_params[:body])
      render json: {message_number: message_number}, status: 200
    end
  end

  def update
    @message.update(@permitted_params)
    render json: {message: @message.as_json(:except => [:id])}, status: 200
  end

  def search
    search_results = Message.search_body(params[:q])
    render json: search_results.as_json(except: [:id, :_id]), status: 200
  end

  private

    def permitted_params
      empty_param("body") && return unless params[:body].present?
      @permitted_params = params.permit(:body)
    end

    def load_chat
      @chat = Chat.find_by(app_token: params[:application_token], chat_number: params[:chat_number])
      object_not_found("chat") && return if @chat.blank?
    end

    def load_message
      @message = Message.find_by(app_token: params[:application_token], chat_number: params[:chat_number], message_number: params[:number])
      object_not_found("message") && return if @message.blank?
    end

end