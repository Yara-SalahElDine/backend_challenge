# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  name           :string(255)      not null
#  chat_number    :integer          not null
#  messages_count :integer          default(0), not null
#  app_token      :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Chat < ApplicationRecord
  include Redis::Objects

  counter :message_counter

  # Relations
  belongs_to :application, foreign_key: 'app_token', primary_key: 'token'

  # Validations
  validates :name, :chat_number, :messages_count, :app_token, presence: true
  validates :app_token, uniqueness: { scope: :chat_number }

  # Callbacks
  after_create :calculate_chats_count

  def messages
    Message.where(app_token: app_token, chat_number: chat_number)
  end

  private

    def calculate_chats_count
      CalculateChatsCountWorker.perform_in(5.seconds, app_token)
    end

end
