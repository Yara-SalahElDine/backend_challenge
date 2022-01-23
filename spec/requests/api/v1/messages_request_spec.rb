require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Messages", type: :request do

  path '/api/v1/applications/{application_token}/chats/{chat_number}/messages' do

    get 'get messages' do
      tags 'Message'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :chat_number, in: :path, type: :string, description: 'Chat number', required: true
      response '200', 'get messages' do
        schema '$ref' => '#/definitions/messages/messages_array'
        it 'gets messages successfully' do
          message = FactoryBot.create(:message)
          get api_v1_application_chat_messages_path(message.app_token, message.chat_number)
          expect(response.status).to eq(200)
          expect(response.body).to include(message.app_token)
        end
      end

      response '404', 'chat not found' do
        it 'does not get messages, if chat does not exist' do
          message = FactoryBot.create(:message)
          get api_v1_application_chat_messages_path("123_token", message.message_number)
          expect(response.status).to eq(404)
          expect(response.body).to include('chat_not_found')
        end
      end
    end

    post 'creates a message' do
      tags 'Message'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :chat_number, in: :path, type: :string, description: 'Chat number', required: true
      parameter name: :body, in: :query, type: :string, description: 'Message body', required: true
      response '200', 'message created' do
        schema '$ref' => '#/definitions/messages/message_number'
        it 'creates message successfully' do
          chat = FactoryBot.create(:chat)
          post api_v1_application_chat_messages_path(chat.app_token, chat.chat_number), params: {body: 'Message 1'}
          expect(response.status).to eq(200)
          expect {
            CreateMessageWorker.perform_async(chat.app_token, chat.chat_number, chat.message_counter, 'Message 1')
          }.to change(CreateMessageWorker.jobs, :size).by(1)
          CreateMessageWorker.drain
          expect(Message.last.body).to eq('Message 1')
          expect(Message.last.app_token).to eq(chat.app_token)
          expect(Message.last.message_number).to eq(1)
          expect(Message.count).to eq 1
        end
      end

      response '404', 'chat not found' do
        it 'does not create message, if chat does not exist' do
          chat = FactoryBot.create(:chat)
          post api_v1_application_chat_messages_path('123_token', chat.chat_number), params: {body: 'Message 1'}
          expect(response.status).to eq(404)
          expect(response.body).to include('chat_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not create chat, if name param is empty' do
          chat = FactoryBot.create(:chat)
          post api_v1_application_chat_messages_path(chat.app_token, chat.chat_number), params: {body: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('body_param_is_empty')
          expect(Message.count).to eq 0
        end
      end
    end
  end

  path '/api/v1/applications/{application_token}/chats/{chat_number}/messages/{number}' do

    get 'get a message' do
      tags 'Message'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :chat_number, in: :path, type: :number, description: 'Chat number', required: true
      parameter name: :number, in: :path, type: :number, description: 'Message number', required: true
      response '200', 'get message' do
        schema '$ref' => '#/definitions/messages/message_object'
        it 'gets chat successfully' do
          message = FactoryBot.create(:message)
          get api_v1_application_chat_message_path(message.app_token, message.chat_number, message.message_number)
          expect(response.status).to eq(200)
          expect(response.body).to include(message.app_token)
        end
      end

      response '404', 'message not found' do
        it 'does not get message, if message does not exist' do
          message = FactoryBot.create(:message)
          get api_v1_application_chat_message_path('123_token', message.chat_number, message.message_number)
          expect(response.status).to eq(404)
          expect(response.body).to include('message_not_found')
        end
      end
    end

    put 'updates a message' do
      tags 'Message'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :chat_number, in: :path, type: :number, description: 'Chat number', required: true
      parameter name: :number, in: :path, type: :number, description: 'Message number', required: true
      parameter name: :body, in: :query, type: :string, description: 'Message body', required: true
      response '200', 'chat updated' do
        schema '$ref' => '#/definitions/messages/message_object'
        it 'updates chat successfully' do
          message = FactoryBot.create(:message)
          put api_v1_application_chat_message_path(message.app_token, message.chat_number, message.message_number), params: {body: 'Message 1'}
          expect(response.status).to eq(200)
          expect(Message.last.body).to eq('Message 1')
        end
      end

      response '404', 'message not found' do
        it 'does not get message, if message does not exist' do
          message = FactoryBot.create(:message)
          put api_v1_application_chat_message_path('123_token', message.chat_number, message.message_number), params: {body: 'Message 1'}
          expect(response.status).to eq(404)
          expect(response.body).to include('message_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not update message, if body param is empty' do
          message = FactoryBot.create(:message)
          put api_v1_application_chat_message_path(message.app_token, message.chat_number, message.message_number), params: {body: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('body_param_is_empty')
        end
      end
    end
  end

  path '/api/v1/messages/search?q=' do

    get 'search a message' do
      tags 'Message'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, description: 'keyword', required: true
      response '200', 'search message' do
        it 'searches messages successfully' do

        end
      end
    end
  end


end
