# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      definitions: {
        applications: {
          application_object: {
            type: :object,
            properties: {
              name: {type: :string},
              token: {type: :string},
              chats_count: {type: :number},
              created_at: {type: :string},
              updated_at: {type: :string}
            }
          },
          applications_array: {
            type: :object,
            properties: {
              applications: {
                type: :array,
                items: {
                  '$ref': '#/definitions/applications/application_object'
                }
              }
            }
          }
        },
        chats: {
          chat_object: {
            type: :object,
            properties: {
              name: {type: :string},
              app_token: {type: :string},
              chat_number: {type: :number},
              messages_count: {type: :number},
              created_at: {type: :string},
              updated_at: {type: :string}
            }
          },
         chats_array: {
            type: :object,
            properties: {
              chats: {
                type: :array,
                items: {
                  '$ref': '#/definitions/chats/chat_object'
                }
              }
            }
          },
          chat_number: { 
            type: :object, 
            properties: {
              chat_number: {type: :number}
            }
          }
        },
        messages: {
          message_object: {
            type: :object,
            properties: {
              body: {type: :string},
              app_token: {type: :string},
              chat_number: {type: :number},
              message_number: {type: :number},
              created_at: {type: :string},
              updated_at: {type: :string}
            }
          },
         messages_array: {
            type: :object,
            properties: {
              messages: {
                type: :array,
                items: {
                  '$ref': '#/definitions/messages/message_object'
                }
              }
            }
          },
          message_number: { 
            type: :object, 
            properties: {
              message_number: {type: :number}
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
