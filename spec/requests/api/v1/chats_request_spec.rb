require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Chats", type: :request do

  path '/api/v1/applications/{application_token}/chats' do

    get 'get chats' do
      tags 'Chat'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      response '200', 'get chats' do
        schema '$ref' => '#/definitions/chats/chats_array'
        it 'gets chats successfully' do
          chat = FactoryBot.create(:chat)
          get api_v1_application_chats_path(chat.app_token)
          expect(response.status).to eq(200)
          expect(response.body).to include(chat.app_token)
        end
      end

      response '404', 'application not found' do
        it 'does not get chats, if application does not exist' do
          get api_v1_application_chats_path("123_token")
          expect(response.status).to eq(404)
          expect(response.body).to include('application_not_found')
        end
      end
    end

    post 'creates a chat' do
      tags 'Chat'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :name, in: :query, type: :string, description: 'Chat name', required: true
      response '200', 'chat created' do
        schema '$ref' => '#/definitions/chats/chat_number'
        it 'creates chat successfully' do
          application = FactoryBot.create(:application)
          post api_v1_application_chats_path(application.token), params: {name: 'Chat 1'}
          expect(response.status).to eq(200)
          expect {
            CreateChatWorker.perform_async(application.token, application.chat_counter, 'Chat 1')
          }.to change(CreateChatWorker.jobs, :size).by(1)
          CreateChatWorker.drain
          
          expect(Chat.last.name).to eq('Chat 1')
          expect(Chat.last.app_token).to eq(application.token)
          expect(Chat.count).to eq 1
        end
      end

      response '404', 'application not found' do
        it 'does not create chat, if application does not exist' do
          post api_v1_application_chats_path('123_token'), params: {name: 'Chat 1'}
          expect(response.status).to eq(404)
          expect(response.body).to include('application_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not create chat, if name param is empty' do
          application = FactoryBot.create(:application)
          post api_v1_application_chats_path(application.token), params: {name: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('name_param_is_empty')
          expect(Chat.count).to eq 0
        end
      end
    end
  end

  path '/api/v1/applications/{application_token}/chats/{number}' do

    get 'get a chat' do
      tags 'Chat'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :number, in: :path, type: :number, description: 'Chat number', required: true
      response '200', 'get chat' do
        schema '$ref' => '#/definitions/chats/chat_object'
        it 'gets chat successfully' do
          chat = FactoryBot.create(:chat)
          get api_v1_application_chat_path(chat.app_token, chat.chat_number)
          expect(response.status).to eq(200)
          expect(response.body).to include(chat.app_token)
        end
      end

      response '404', 'chat not found' do
        it 'does not get chat, if chat does not exist' do
          chat = FactoryBot.create(:chat)
          get api_v1_application_chat_path("123_token", chat.chat_number)
          expect(response.status).to eq(404)
          expect(response.body).to include('chat_not_found')
        end
      end
    end

    put 'updates a chat' do
      tags 'Chat'
      produces 'application/json'
      parameter name: :application_token, in: :path, type: :string, description: 'Application token', required: true
      parameter name: :number, in: :path, type: :number, description: 'Chat number', required: true
      parameter name: :name, in: :query, type: :string, description: 'Chat name', required: true
      response '200', 'chat updated' do
        schema '$ref' => '#/definitions/chats/chat_object'
        it 'updates chat successfully' do
          chat = FactoryBot.create(:chat)
          put api_v1_application_chat_path(chat.app_token, chat.chat_number), params: {name: 'Chat 1'}
          expect(response.status).to eq(200)
          expect(Chat.last.name).to eq('Chat 1')
        end
      end

      response '404', 'chat not found' do
        it 'does not update chat, if chat does not exist' do
          chat = FactoryBot.create(:chat)
          put api_v1_application_chat_path("123_token", chat.chat_number), params: {name: 'Chat 1'}
          expect(response.status).to eq(404)
          expect(response.body).to include('chat_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not update chat, if name param is empty' do
          chat = FactoryBot.create(:chat)
          put api_v1_application_chat_path(chat.app_token, chat.chat_number), params: {name: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('name_param_is_empty')
        end
      end
    end
  end


end
