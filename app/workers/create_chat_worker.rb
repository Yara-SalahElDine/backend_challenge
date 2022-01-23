class CreateChatWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'create_chat'

  def perform(app_token, chat_number, name)
    Chat.create(name: name, app_token: app_token, chat_number: chat_number)
  end
end
