class CalculateMessagesCountWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'calculate_messages_count', lock_ttl: 5.seconds, lock: :until_executing

  def perform(token, chat_number)
    chat = Chat.find_by(app_token: token, chat_number: chat_number)
    chat.update_column(:messages_count, chat.messages.count)
  end
end
