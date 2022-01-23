# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  body           :text(65535)      not null
#  message_number :integer          not null
#  chat_number    :integer          not null
#  app_token      :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'elasticsearch/model'
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # Relations
  belongs_to :application, foreign_key: 'app_token', primary_key: 'token'

  # Validations
  validates :body, :message_number, :chat_number, :app_token, presence: true
  validates :app_token, uniqueness: {
    scope: [ :chat_number, :message_number ]
  }

  # Callbacks
  after_create :calculate_messages_count

  settings do
    mappings dynamic: false do
      indexes :body, type: :text, analyzer: :english
    end
  end

  def self.search_body(text)
    query = {
      query: {
        wildcard: {
          body: {
            value: "*#{text}*"
          }
        }
      }
    }
    Message.search(query)
  end

  def chat
    Chat.find_by(app_token: app_token, chat_number: chat_number)
  end


  private

    def calculate_messages_count
      CalculateMessagesCountWorker.perform_in(5.seconds, app_token, chat_number)
    end

end
