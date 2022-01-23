require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Api::V1::Applications', type: :request do

  path '/api/v1/applications' do

    get 'get applications' do
      tags 'Application'
      produces 'application/json'
      response '200', 'get applications' do
        schema '$ref' => '#/definitions/applications/applications_array'
        it 'gets applications successfully' do
          application = FactoryBot.create(:application)
          get api_v1_applications_path
          expect(response.status).to eq(200)
          expect(response.body).to include(application.token)
        end
      end
    end

    post 'creates an application' do
      tags 'Application'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string, description: 'Application name', required: true
      response '200', 'application created' do
        schema '$ref' => '#/definitions/applications/application_object'
        it 'creates application successfully' do
          post api_v1_applications_path, params: {name: 'Application 1'}
          expect(response.status).to eq(200)
          expect(Application.last.name).to eq('Application 1')
          expect(Application.count).to eq 1
        end
      end

      response '422', 'invalid request' do
        it 'does not create application, if name param is empty' do
          post api_v1_applications_path, params: {name: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('name_param_is_empty')
          expect(Application.count).to eq 0
        end
      end
    end
  end

  path '/api/v1/applications/{token}' do

    get 'get an application' do
      tags 'Application'
      produces 'application/json'
      parameter name: :token, in: :path, type: :string, description: 'Token', required: true
      response '200', 'get application' do
        schema '$ref' => '#/definitions/applications/application_object'
        it 'gets application successfully' do
          application = FactoryBot.create(:application)
          get api_v1_application_path(application.token)
          expect(response.status).to eq(200)
          expect(response.body).to include(application.token)
        end
      end

      response '404', 'application not found' do
        it 'does not update application, if application does not exist' do
          get api_v1_application_path('123_token')
          expect(response.status).to eq(404)
          expect(response.body).to include('application_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not update application, if name param is empty' do
          application = FactoryBot.create(:application)
          put api_v1_application_path(application.token), params: {name: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('name_param_is_empty')
        end
      end
    end

    put 'updates an application' do
      tags 'Application'
      produces 'application/json'
      parameter name: :token, in: :path, type: :string, description: 'Token', required: true
      parameter name: :name, in: :query, type: :string, description: 'Application name', required: true
      response '200', 'application updated' do
        schema '$ref' => '#/definitions/applications/application_object'
        it 'updates application successfully' do
          application = FactoryBot.create(:application)
          put api_v1_application_path(application.token), params: {name: 'Application 1'}
          expect(response.status).to eq(200)
          expect(Application.last.name).to eq('Application 1')
        end
      end

      response '404', 'application not found' do
        it 'does not update application, if application does not exist' do
          put api_v1_application_path('123_token'), params: {name: 'Application 1'}
          expect(response.status).to eq(404)
          expect(response.body).to include('application_not_found')
        end
      end

      response '422', 'invalid request' do
        it 'does not update application, if name param is empty' do
          application = FactoryBot.create(:application)
          put api_v1_application_path(application.token), params: {name: ''}
          expect(response.status).to eq(422)
          expect(response.body).to include('name_param_is_empty')
        end
      end
    end
  end


end
