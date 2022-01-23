class CalculateChatsCountWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'calculate_chats_count', lock_ttl: 5.seconds, lock: :until_executing

  def perform(token)
    application = Application.find_by_token(token)
    application.update_column(:chats_count, application.chats.count)
  end
end
